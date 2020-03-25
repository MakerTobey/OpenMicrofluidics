/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Optics unit                             *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* The optics module holds the camera and whatever lens you are    *
* using as an objective - current options are either the lens     *
* from the Raspberry Pi camera module, or an RMS objective lens   *
* and a second "tube length conversion" lens (usually 40mm).      *
*                                                                 *
* See the section at the bottom of the file for different         *
* versions, to suit different combinations of optics/cameras.     *
* NB you set the camera in the variable at the top of the file.   *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <utilities.scad>;
use <dovetail.scad>;
use <z_axis.scad>;
include <microscope_parameters.scad>; // NB this defines "camera" and "optics"
use <thorlabs_threads.scad>;

use <cameras/camera.scad>; // this will define the 2 functions and 1 module for the camera mount, using the camera defined in the "camera" parameter.

dt_bottom = -2; //where the dovetail starts (<0 to allow some play)
camera_mount_top = dt_bottom - 3 - (optics=="rms_f50d13"?8:0) - (optics=="rms_infinity_f50d13"?20:0); //the 50mm tube lens requires the camera to stick out the bottom.
bottom = camera_mount_top-camera_mount_height(); //nominal distance from PCB to microscope bottom
fl_cube_bottom = optics=="rms_f50d13"?-8:0; //bottom of the fluorescence filter cube
fl_cube_top = fl_cube_bottom + fl_cube_w + 2.7; //top of fluorescence cube
fl_cube_top_w = fl_cube_w - 2.7;
d = 0.05;
$fn=24;

function fl_cube_width() = fl_cube_w;

module fl_cube_cutout(taper=true){
    // A cut-out that enables a filter cube to be inserted.
    union(){
        sequential_hull(){
            translate([-fl_cube_w/2,-fl_cube_w/2,fl_cube_bottom]) cube([fl_cube_w,999,fl_cube_w]);
            translate([-fl_cube_w/2+2,-fl_cube_w/2,fl_cube_bottom]) cube([fl_cube_w-4,999,fl_cube_w+2]); //sloping sides
            translate([-fl_cube_w/2+2,-fl_cube_w/2+2,fl_cube_bottom]) cube([fl_cube_w-4,fl_cube_w-4,fl_cube_w+2]);
            if(taper) translate([-d,-d,fl_cube_bottom]) cube([2*d,2*d,fl_cube_w*1.5]); //taper gradually to the diameter of the beam
        }
        //a space at the back to allow the grippers for the dichroics to extend back a bit further.
        hull(){
            translate([-fl_cube_w/2+2,-fl_cube_w/2-1,fl_cube_bottom]) cube([fl_cube_w-4,999,fl_cube_w]);
            translate([-fl_cube_w/2+4,-fl_cube_w/2,fl_cube_bottom]) cube([fl_cube_w-8,999,fl_cube_w+2]);
        }
            
    }
}
module optical_path(lens_aperture_r, lens_z){
    // The cut-out part of a camera mount, consisting of
    // a feathered cylindrical beam path.  Camera mount is now cut out
    // of the camera mount body already.
    union(){
        translate([0,0,camera_mount_top-d]) lighttrap_cylinder(r1=5, r2=lens_aperture_r, h=lens_z-camera_mount_top+2*d); //beam path
        translate([0,0,lens_z]) cylinder(r=lens_aperture_r,h=2*d); //lens
    }
}
module optical_path_fl(lens_aperture_r, lens_z){
    // The cut-out part of a camera mount, with a space to slot in a filter cube.
    union(){
        translate([0,0,camera_mount_top-d]) lighttrap_sqylinder(r1=5, f1=0,
                r2=0, f2=fl_cube_w-4, h=fl_cube_bottom-camera_mount_top+2*d); //beam path to bottom of cube
        rotate(180) fl_cube_cutout(); //filter cube
        translate([0,0,fl_cube_top-d]) lighttrap_sqylinder(r1=1.5, f1=fl_cube_w-4-3, r2=lens_aperture_r, f2=0, h=lens_z-fl_cube_top+4*d); //beam path
        translate([0,0,lens_z]) cylinder(r=lens_aperture_r,h=2*d); //lens
    }
}
    
module lens_gripper(lens_r=10,h=6,lens_h=3.5,base_r=-1,t=0.65,solid=false, flare=0.4){
    // This creates a tapering, distorted hollow cylinder suitable for
    // gripping a small cylindrical (or spherical) object
    // The gripping occurs lens_h above the base, and it flares out
    // again both above and below this.
    trylinder_gripper(inner_r=lens_r, h=h, grip_h=lens_h, base_r=base_r, t=t, solid=solid, flare=flare);
}

module camera_mount_top(){
    // A thin slice of the top of the camera mount
    linear_extrude(d) projection(cut=true) camera_mount();
}
module objective_fitting_base(){
    // A thin slice of the mounting wedge that bolts to the microscope body
    linear_extrude(d) projection() objective_fitting_wedge();
}

module camera_mount_body(
        body_r, //radius of mount body
        body_top, //height of the top of the body
        dt_top, //height of the top of the dovetail
        extra_rz = [], //extra [r,z] values to extend the mount
        bottom_r=8, //radius of the bottom of the mount
        fluorescence=false, //whether to leave a port for fluorescence beamsplitter etc.
        dt_waist=true, //whether to make the middle of the dovetail looser for easy insertion
        dovetail=true //set this to false to remove the attachment point
    ){
    // Make a camera mount, with a cylindrical body and a dovetail.
    // Just add a lens mount on top for a complete optics module!
    dt_h=dt_top-dt_bottom;
    union(){
        difference(){
            // This is the main body of the mount
            sequential_hull(){
                translate([0,0,camera_mount_top]) camera_mount_top();
                translate([0,0,dt_bottom]) hull(){
                    cylinder(r=bottom_r,h=d);
                    if(dovetail) objective_fitting_base();
                    if(fluorescence) cube([1,1,0]*(fl_cube_w+2) + [0,0,d], center=true);
                }
                translate([0,0,dt_bottom]) hull(){
                    cylinder(r=bottom_r,h=d);
                    if(fluorescence) cube([1,1,0]*(fl_cube_w+2) + [0,0,d], center=true);
                    if(dovetail) objective_fitting_base();
                }
                union(){
                    if(fluorescence) translate([0,0,fl_cube_bottom + fl_cube_w]){
                        cube([1,1,0]*(fl_cube_w+2) + [0,0,d], center=true);
                        cylinder(r=body_r,h=d);
                    }
                    translate([0,0,body_top]) cylinder(r=body_r,h=d);
                    if(dovetail) translate([0,0,dt_top]) objective_fitting_base();
                }
                // allow for extra coordinates above this, if wanted.
                // this should really be done with a for loop, but
                // that breaks the sequential_hull, hence the kludge.
                if(len(extra_rz) > 0) translate([0,0,extra_rz[0][1]-d]) cylinder(r=extra_rz[0][0],h=d);
                if(len(extra_rz) > 1) translate([0,0,extra_rz[1][1]-d]) cylinder(r=extra_rz[1][0],h=d);
                if(len(extra_rz) > 2) translate([0,0,extra_rz[2][1]-d]) cylinder(r=extra_rz[2][0],h=d);
                if(len(extra_rz) > 3) translate([0,0,extra_rz[3][1]-d]) cylinder(r=extra_rz[3][0],h=d);
            }
            
            // fitting for the objective mount
            //translate([0,0,dt_bottom]) objective_fitting_wedge();
            // Mount for the nut that holds it on
            translate([0,0,-1]) objective_fitting_cutout();
        }
        
        // add the camera mount
        translate([0,0,camera_mount_top]) camera_mount();
    }
}

module rms_mount_and_tube_lens_gripper(){
    // This assembly holds an RMS objective and a correcting
    // "tube" lens.  I dont think this is used any more...
    union(){
        lens_gripper(lens_r=rms_r, lens_h=lens_assembly_h-2.5,h=lens_assembly_h, base_r=lens_assembly_base_r);
        lens_gripper(lens_r=tube_lens_r, lens_h=3.5,h=6);
        difference(){
            cylinder(r=tube_lens_aperture + 1.0,h=2);
            cylinder(r=tube_lens_aperture,h=999,center=true);
        }
    }
}

module optics_module_rms(tube_lens_ffd=16.1, tube_lens_f=20, 
    tube_lens_r=16/2+0.2, objective_parfocal_distance=35, tube_length=150, fluorescence=false, gripper_t=1, dovetail=true){
    // This optics module takes an RMS objective and a tube length correction lens.
    // important parameters are below:
        
    rms_r = 20/2; //radius of RMS thread, to be gripped by the mount
    //tube_lens_r (argument) is the radius of the tube lens
    //tube_lens_ffd (argument) is the front focal distance (from flat side to focus) - measure this, or take it from the lens spec. sheet
    //tube_lens_f (argument) is the nominal focal length of the tube lens.
    tube_lens_aperture = tube_lens_r - 1.5; // clear aperture of the tube lens
    pedestal_h = 2; // height of tube lens above bottom of lens assembly (to allow for flex)
    //sample_z (microscope_parameters.scad) // height of the sample above the bottom of the microscope (depends on size of microscope)
    dovetail_top = min(27, sample_z-objective_parfocal_distance-0.5); //height of the top of the dovetail, i.e. the position of the objective's "shoulder"
    //tube_length (argument) is the distance behind the objective's "shoulder" where the image is formed.  This should be infinity (safe to use 9999) for infinity-corrected lenses, or 150 for 160mm tube length objectives (the image is formed ~10mm from the end of the tube).
    
    ///////////////// Lens position calculation //////////////////////////
    // calculate the position of the tube lens based on a thin-lens
    // approximation: the light is focussing from the objective shoulder
    // to a point 160mm away, but we want to refocus it so it's
    // closer (i.e. focusses at the bottom of the mount).  If we let:
    // dos = distance from objective to sensor
    // dts = distance from tube lens to sensor
    // ft = focal length of tube lens
    // fo = tube length of objective lens
    // then 1/dts = 1/ft + 1/(fo-dos+dts)
    // the solution to this, if b=fo-dos and a=ft, is:
    // dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b)
    a = tube_lens_f;
    dos = sample_z - objective_parfocal_distance - bottom - camera_sensor_height(); //distance from the sensor to the objective shoulder
    echo("Objective to sensor:",dos);
    b = tube_length - dos;
    dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b);
    echo("Distance from tube lens principal plane to sensor:",dts);
    // that's the distance to the nominal "principal plane", in reality
    // we measure the front focal distance, and shift accordingly:
    tube_lens_z = bottom + camera_sensor_height() + dts - (tube_lens_f - tube_lens_ffd);
        
    // having calculated where the lens should go, now make the mount:
    lens_assembly_z = tube_lens_z - pedestal_h; //height of lens assembly
    lens_assembly_base_r = rms_r+1; //outer size of the lens grippers
    lens_assembly_h = sample_z-lens_assembly_z-objective_parfocal_distance; //the
        //objective sits parfocal_distance below the sample
    union(){
        // The bottom part is just a camera mount with a flat top
        difference(){
            // camera mount with a body that's shorter than the dovetail
            camera_mount_body(body_r=lens_assembly_base_r, bottom_r=10.5, body_top=lens_assembly_z, dt_top=dovetail_top,fluorescence=fluorescence, dovetail=dovetail);
            // camera cut-out and hole for the beam
            if(fluorescence){
                optical_path_fl(tube_lens_aperture, lens_assembly_z);
            }else{
                optical_path(tube_lens_aperture, lens_assembly_z);
            }
            // make sure the camera mount makes contact with the lens gripper, but
            // doesn't foul the inside of it
            translate([0,0,lens_assembly_z]) lens_gripper(lens_r=rms_r-d, lens_h=lens_assembly_h-2.5,h=lens_assembly_h, base_r=lens_assembly_base_r-d, solid=true); //same as the big gripper below
            
        }
        // A threaded hole for the objective with a lens gripper for the tube lens
        translate([0,0,lens_assembly_z]){
            // threaded cylinder for the objective
            radius=25.4*0.8/2-0.25; //Originally this was 9.75, is that a fudge factor, or allowance for the thread?;
            pitch=0.7056;
            difference(){
                hull(){
                    cylinder(r=lens_assembly_base_r,h=d,$fn=50);
                    translate([0,0,lens_assembly_h-5]) cylinder(r=radius+1.2+0.44, h=5);
                }
                sequential_hull(){
                    cylinder(r=lens_assembly_base_r-1, h=2*d,center=true,$fn=50);
                    translate([0,0,lens_assembly_h-5]) cylinder(r=radius+0.44,h=d,$fn=100);
                    translate([0,0,999]) cylinder(r=radius+0.44,h=d,$fn=100);
                }
            }
            translate([0,0,lens_assembly_h-5]) inner_thread(radius=radius,threads_per_mm=pitch,thread_base_width = 0.60,thread_length=5);
            // gripper for the objective (disabled in favour of the thread)
            //lens_gripper(lens_r=rms_r, lens_h=lens_assembly_h-2.5,h=lens_assembly_h, base_r=lens_assembly_base_r, t=gripper_t);
            // gripper for the tube lens
            lens_gripper(lens_r=tube_lens_r, lens_h=pedestal_h+1,h=pedestal_h+1+2.5, t=gripper_t);
            // pedestal to raise the tube lens up within the gripper
            difference(){
                cylinder(r=tube_lens_aperture + 1.0,h=2);
                cylinder(r=tube_lens_aperture,h=999,center=true);
            }
        }
    }
}


module rms_camera_tube(tube_length=150){
    // This optics module takes an RMS objective and a tube length correction lens.
    // important parameters are below:
        
    rms_r = 20/2; //radius of RMS thread, to be gripped by the mount
    //tube_lens_r (argument) is the radius of the tube lens
    //tube_lens_ffd (argument) is the front focal distance (from flat side to focus) - measure this, or take it from the lens spec. sheet
    //tube_lens_f (argument) is the nominal focal length of the tube lens.
    //tube_length (argument) is the distance behind the objective's "shoulder" where the image is formed.  This should be 150 for 160mm tube length objectives (the image is formed ~10mm from the end of the tube).
    
    
    lens_assembly_z = bottom + tube_length - 10; //height of lens assembly
    lens_assembly_base_r = rms_r+1; //outer size of the lens grippers
    lens_assembly_h = 10; //the
        //objective sits parfocal_distance below the sample
    union(){
        // The bottom part is just a camera mount with a flat top
        difference(){
            // camera mount with a body that's shorter than the dovetail
            camera_mount_body(body_r=lens_assembly_base_r, bottom_r=10.5, body_top=lens_assembly_z, dt_top=lens_assembly_z+5,fluorescence=false, dt_waist=false);
            // camera cut-out and hole for the beam
            optical_path(6, lens_assembly_z);
            // make sure it makes contact with the lens gripper, but
            // doesn't foul the inside of it
            translate([0,0,lens_assembly_z]) lens_gripper(lens_r=rms_r-d, lens_h=lens_assembly_h-2.5,h=lens_assembly_h, base_r=lens_assembly_base_r-d, solid=true); //same as the big gripper below
            
        }
        // A pair of nested lens grippers to hold the objective
        translate([0,0,lens_assembly_z]){
            // gripper for the objective
            lens_gripper(lens_r=rms_r, lens_h=lens_assembly_h-2.5,h=lens_assembly_h, base_r=lens_assembly_base_r);
        }
    }
}

module optics_module_trylinder(
        lens_r = 14/2, //radius of lens
        parfocal_distance = 20, //distance from back of lens to sample
        lens_h = 5.5 //height of lens (will be gripped 1mm below)
    ){
    // This optics module grips a single lens at the top.
    lens_aperture = lens_r - 1.5; // clear aperture of the lens
    pedestal_h = 4; // extra height on the gripper, to allow it to flex
    dovetail_top = min(27, sample_z-parfocal_distance+lens_h-1); //height of the top of the dovetail
    
    lens_z = sample_z - parfocal_distance; //axial position of lens
        
    // having calculated where the lens should go, now make the mount:
    lens_assembly_z = lens_z - pedestal_h; //height of lens assembly
    lens_assembly_base_r = lens_r+1; //outer size of the lens grippers
    lens_assembly_h = lens_h + pedestal_h; //the
                                            //lens sits parfocal_distance below the sample
    union(){
        // The bottom part is just a camera mount with a flat top
        difference(){
            // camera mount with a body that's shorter than the dovetail
            camera_mount_body(body_r=lens_assembly_base_r, bottom_r=7, body_top=lens_assembly_z, dt_top=min(lens_assembly_z, z_flexures_z2));
            // camera cut-out and hole for the beam
            optical_path(lens_aperture, lens_assembly_z);
        }
        // A lens gripper to hold the objective
        translate([0,0,lens_assembly_z]){
            // gripper
            trylinder_gripper(inner_r=lens_r, grip_h=lens_assembly_h-1.5,h=lens_assembly_h, base_r=lens_assembly_base_r, flare=0.4, squeeze=lens_r*0.15);
            // pedestal to raise the tube lens up within the gripper
            difference(){
                cylinder(r=lens_aperture + 1.0,h=pedestal_h);
                cylinder(r=lens_aperture,h=999,center=true);
            }
        }
    }
}

module condenser(){
    // A simple one-lens condenser, re-imaging the LED onto the sample.
    lens_z = 17;
    pedestal_h = 3;
    lens_r = 13/2;
    aperture_r = lens_r-1.1;
    lens_t = 1;
    base_r = lens_r+2;
    union(){
        //lens gripper to hold the plastic asphere
        translate([0,0,lens_z-pedestal_h]){
            // gripper
            trylinder_gripper(inner_r=lens_r, grip_h=pedestal_h + lens_t/3,h=pedestal_h+lens_t+1.5, base_r=base_r, flare=0.5);
            // pedestal to raise the tube lens up within the gripper
            difference(){
                cylinder(r=aperture_r+0.8,h=pedestal_h);
                cylinder(r=aperture_r,h=999,center=true);
            }
        }
        //bottom part
        difference(){
            union(){
                cylinder(r=base_r, h=lens_z-pedestal_h+d);
                //dovetail
                translate([0,condenser_clip_y,0]) mirror([0,1,0]) dovetail_m([condenser_clip_w,4,lens_z-pedestal_h]);
            }
            
            //LED
            deformable_hole_trylinder(led_r,led_r+0.7,h=20, center=true);
            cylinder(r=led_r+1.0,h=2,center=true);
            translate([0,0,2-d]) cylinder(r1=led_r+1.0, r2=led_r,h=2,center=true);
            
            //beam
            translate([0,0,5]) cylinder(r1=led_r,r2=aperture_r,h=lens_z-5);
        }
    }
}
//optics="beamsplitter_led_mount";
//optics="rms_f50d13";
//camera="picamera2";
difference(){
    if(optics=="pilens"){
        // Optics module for picamera v2 lens, using trylinder
        optics_module_trylinder(
            lens_r = 3, 
            parfocal_distance = 6,
            lens_h = 2.5
        );
        if(sample_z > 40) echo("Warning: using the pi camera lens with a tall stage gives fuzzy images!");
    }else if(optics=="c270_lens"){
        // Optics module for logitech C270 lens
        optics_module_trylinder(
            lens_r = 6,
            parfocal_distance = 6, //NB with 6 here the PCB is a bit low
            lens_h = 2
        );
    }else if(optics=="rms_f40d16"){
        // Optics module for RMS objective, using Comar 40mm singlet tube lens
        optics_module_rms(
            tube_lens_ffd=38, 
            tube_lens_f=40, 
            tube_lens_r=16/2+0.1, 
            objective_parfocal_distance=35,
            fluorescence=beamsplitter,
            gripper_t=0.65,
            tube_length=150
        );
        if(sample_z < 60 || objective_mount_y < 12) echo("Warning: RMS objectives won't fit in small microscope frames!");
    }else if(optics=="rms_f50d13" || optics=="rms_infinity_f50d13"){
        // Optics module for RMS objective using ThorLabs ac127-050-a doublet tube lens
        optics_module_rms(
            tube_lens_ffd=47, 
            tube_lens_f=50, 
            tube_lens_r=12.7/2+0.1, 
            objective_parfocal_distance=35,
            fluorescence=beamsplitter,
            tube_length=(optics=="rms_f50d13" ? 150 : 99999) //use 150 for standard finite-conjugate objectives (cheap ones) or 9999 for infinity-corrected lenses (usually more expensive).
        );
        if(sample_z < 60 || objective_mount_y < 12) echo("Warning: RMS objectives won't fit in small microscope frames!");
    }else if(optics=="m12_lens"){
        // Optics module for USB camera's M12 lens
        optics_module_trylinder(
            lens_r = 14/2,
            parfocal_distance = 21, //22 for high-res lens
            lens_h = 5.5
        );
        if(objective_mount_y < 10) echo("Warning: M12 lenses won't fit in small frames");
    }
    
    //picam_cover();
    //translate([0,objective_mount_y-7,0]) rotate([90,0,0]) cylinder(r=999,h=999,$fn=8);
    //mirror([0,0,1]) cylinder(r=999,h=999,$fn=8);
    //C270 lens could be a trylinder gripper, with lens_r=12.0, lens_h=1 and a pedestal that is smaller than the gripper by more than the usual amount (say 1mm space)
    //translate([0,0,21]) mirror([0,0,1]) cylinder(r=999,h=999);
}
//condenser();
