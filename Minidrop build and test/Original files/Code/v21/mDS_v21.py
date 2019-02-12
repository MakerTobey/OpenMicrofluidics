#!/usr/bin/env python3

#==============================================================
#
# Shell program Authors:      Christine Smythe and Colin Smythe (Dunelm Services Limited)
#
# Author:       William Stephenson
# Version/Date: v21 8/2/2017
# Notes:        Heavily modified for miniDrops system      
#
# Description:  This simple Python3 program is used to take a single photo,
#               or a video with the RPi-Camera. 
#               This program requires Python3.
#
#               For a single photo the user needs to enter a filename eg myphoto
#               to which the program will add .jpg
#               The file will be created in the users current directory -
#               so make sure you are in the right current working
#               directory before running the program.
#               If you chose a filename already in use the contents will be
#               overwritten by the new photo
#
#               For a video the user needs to specify a filename eg myvideo to which
#               the program will add .h264
#               then press 'Start video' to start recording and
#               'Stop video' to stop recording.
#
#               Please ensure you press 'QUIT' rather than closing the window in order to 
#               cleanly close the camera preview window.
#
#               If you want to view any of the images then simply use the file manager and
#               double click on the filename. This doesn't work for videos.
#
#               The program also contains buttons for opening/closing a set of solenoids. 
#               This is a single signal (GPIO pin = 18, BCM numbering) either HIGH or LOW
#
#               Additionally the program runs background control of stepper motor rotaiton. 
#               Parameters for no. of steps, speed, and wait time can be found in the worker 
#               function at the bottom of the program.
#
#               Pressures are read through an SPI interface in ADC and require spidev package.
#
#               MicroAir pump is controlled through "PUMP ON/OFF" buttons.
#
# History:      Original release.
#
# Copyright:    2013 (c) Premier Farnell Limited
#
# License:      GPLv3+
#
#==============================================================

import tkinter as tk
from tkinter import *
from time import sleep
import picamera
import os
import sys
import RPi.GPIO as GPIO
import spidev
import threading
import multiprocessing
import logging

#######################################################
# Honeywell Pressure sensor calibration parameters 
m = 55.596 # slope [bits/PSI]
b = 102.4  # intercept [bits]
#######################################################


#######################################################
# Setup GPIO pin(s)
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

DIR_PIN = 19    # Stepper motor Direction PIN
STEP_PIN = 20   # Stepper motor Step PIN

sol1_pin = 22    # Solenoid 1 PIN
sol2_pin = 23    # Solenoid 2 PIN

pump_pin = 27


GPIO.setup(sol1_pin, GPIO.OUT)        
GPIO.output(sol1_pin, False)          

GPIO.setup(sol2_pin, GPIO.OUT)
GPIO.output(sol2_pin, False)

GPIO.setup(pump_pin, GPIO.OUT)
GPIO.output(pump_pin, False)

GPIO.setup(DIR_PIN, GPIO.OUT)
GPIO.setup(STEP_PIN, GPIO.OUT)
#######################################################


#######################################################
# Setup SPI protocol for Analog-to-Digital Converter
spi = spidev.SpiDev()
spi.open(0,0)
#######################################################

#==============================================================
# Declaration of Constants
# none used

#==============================================================


class Application(Frame):
    """ GUI Application for taking photos. """
    def __init__(self, master):
        super(Application, self).__init__(master)
        self.grid()
        self.create_widgets()
        self.setup_camera()
        self.poll()
        
    #.................Method: create widgets..........................
    # This creates a window with buttons 
    #   - to take a single photo or a video.
    #   SA single photo just needs the user to enter a filename to put
    #   the photo in. The filename is appended with .jpg and the file
    #   placed in the users current directory.
    # 
    #   A video needs a filename to store the video in adn again will be
    #   created in the users current directory.
    #

    
    def create_widgets(self):
        """ Create widgets for photos. """

        #setup widgets to get filename for single photo
        Label(self, text = "Image Filename:").grid(row = 0, column = 0, sticky = N+S)
        self.s_filename = Entry(self)
        self.s_filename.grid(row = 1, column = 0)

        # create 'Take Image' button
        Button( self,
                text = "Take Image",
                command = self.action_camera,
                bg='white',
                ).grid(row=2, column = 0, sticky = N+S)

        
        #setup widgets to get filename for video
        Label(self, text = "Video Filename :").grid(row = 0, column = 1, sticky = N+S)
        self.v_filename = Entry(self)
        self.v_filename.grid(row = 1, column = 1)

        Label(self, text = 'Oil Pressure:').grid(row = 6, column = 0, sticky = E)
        Label(self, textvariable = press1).grid(row = 6, column = 1, sticky = W)
        Label(self, text = 'Aq. Pressure:').grid(row = 5 , column = 0, sticky = E)
        Label(self, textvariable = press2).grid(row = 5, column = 1, sticky = W)

        # create 'RUN' Button
        Button( self,
                text = "RUN",
                command = self.open_solenoids,
                bg='green',
                ).grid(row=8, column = 0, sticky = E+N+S)


        # CREATE 'STOP' Button
        Button( self,
                text = "STOP",
                command = self.close_solenoids,
                bg='red',
                ).grid(row=8, column = 1, sticky = W+N+S)

        # create 'Start Video' button
        Button( self,
                text = "Start video",
                command = self.start_video,
                bg='green',
                ).grid(row=2, column = 1, sticky = N+S)

        # create 'Stop video' button
        Button( self,
                text = "Stop Video",
                command = self.stop_video,
                bg='green',
                ).grid(row=3, column = 1, sticky = N+S)

        # create 'PUMP-ON' button
        Button( self,
                text = "PUMP ON",
                command = self.pump_on,
                bg='green',
                ).grid(row=7, column = 0, sticky = W+E+N+S)

        # create 'PUMP-OFF' button
        Button( self,
                text = "PUMP OFF",
                command = self.pump_off,
                bg='red',
                ).grid(row=7, column = 1, sticky = W+E+N+S)

        # create 'QUIT' button
        Button( self,
                text = "QUIT",
                command = self.exit_camera,
                bg='red',
                ).grid(row=9, column = 1, sticky = W+E+N+S)

        # create text field to display results
        self.results_txt = Text(self, height = 2, wrap = WORD)
        self.results_txt.grid(row = 10, column = 0, columnspan=2)
        
        
    def poll(self):
        self.master.after(250, self.poll)

    #.................... Method: choose_single_photo ................
    # This method selects the single photo option
    # and asks the user to enter a filename and press ACTION 
    #
    def choose_single_photo(self):
        self.chosenfile = StringVar()
        self.chosenfile.set(None)
        status = ""
        status = "You have chosen to take a single photo.\n"
        status = "Make sure you have entered a filename then\n"
        status += "press 'Execute' when ready\n" 
        self.results_txt.delete(0.0, END)
        self.results_txt.insert(0.0, status)        
 
    # ................. end of method choose_single_photo .................

    #.................... Method: action_camera ................
    # This method calls appropriate method depending on which
    # photo option user has chosen
    #
    def action_camera(self):
        status = ""
        self.action_single()
    

    # ................. end of method action camera .................

    
    
    #.................... Method: action_single ................
    # This method takes a single photo
    # and updates the status display to show the name of the file it is saved in
    #
    def action_single(self):
        status = ""
        numphotos = 1
        numsecs = 1
        chosenfile = ""

        #first get filename
        contents= self.s_filename.get()
        #convert to string and add .jpg
        self.chosenfile= str(contents)+ ".jpg"
        status = "\nchosen filename : " + self.chosenfile + "     "

        #now take photo
        try:
            self.camera.capture(self.chosenfile)
            status += "captured image - " + self.chosenfile
        except:
           status += "Invalid file namechosen - " + self.chosenfile

        self.results_txt.delete(5.0, END)
        self.results_txt.insert(5.0, status)

    # ................. end of action_single .................
    
    
    #.................... Method: start_video ................
    # This method gets the filename the user has entered, starts the video
    # and updates the status display to show the name of the file it is saved in
    #
    def start_video(self):
        status = ""
        chosenfile = ""

        #first get filename
        contents= self.v_filename.get()
        #convert to string and add .h264 for file format
        self.chosenfile= str(contents) + ".h264"
        status = "chosen filename : " + self.chosenfile + "\n"
 
        # now start the recording
        try:
            status += "\nStarting to record   \n"
            self.camera.start_recording(self.chosenfile)
        except:
            status += "Invalid file name chosen - " + self.chosenfile + "\n"          

        self.results_txt.delete(0.0, END)
        self.results_txt.insert(0.0, status)

    # ................. end of start_video .................
    

    #.................... Method: stop_video ................
    # This method stops the video recording
    # and updates the status display 
    #
    def stop_video(self):
        status = ""
        chosenfile = ""
        try:
            self.camera.stop_recording()
            status += "stopped recording \n " 
        except:
            status += "Error on stop recording \n"     

        self.results_txt.delete(6.0, END)
        self.results_txt.insert(6.0, status)

    # ................. end of stop_video .................
    
      
    #.................... Method: exit_camera ................
    # This method closes down the camera nicely and exits
    #
    def exit_camera(self):
        status = ""
        useranswer = ""
        useranswer = "no"
        cancelquestion = "You are still recording a video.\nDo you wish to stop recording ?"

        #first check to see if camera is currently recording a video
        if self.camera.recording == True:
            # yes it is recording so ask user if they wish to stop recording
            useranswer=messagebox.askquestion("Exit Error!",
-                                         cancelquestion)
            if useranswer == "yes" :
                #if user says yes- stop then stop the recording and cleanup for exit
                self.camera.stop_recording()
                self.camera.stop_preview()
                self.camera.close()
                GPIO.cleanup()
                root.destroy()
            else:
                # otherwise user does not wish to stop so ignore stop request
                status += "continuing recording   \n"
                self.results_txt.delete(7.0, END)
                self.results_txt.insert(7.0, status)
        else :
            # camera isn't currently recording a video so cleanup for exit.
            self.camera.stop_preview()
            self.camera.close()
            self.close_solenoids()
            self.pump_off()
            self.quit()
            root.quit()
            root.destroy()


    # ................. end of method: exit_camera .................


    #.................... Method: start_camera ................
    # This method starts the camera.
    #
    def setup_camera(self):
        # instantiate the camera
        self.camera = picamera.PiCamera()
        # change the resolution so it is a smaller window
        # which will fit on screen with GUI window
        window_width = 250
        window_height = 400
        self.camera.resolution = (window_width,window_height)
        # make it a smaller preview window which will fit on screen with GUI window
        self.camera.preview_fullscreen = False
        self.camera.zoom = (0.5, 0.5, 1.0, 1.0)
        self.camera.hflip = True
        self.camera.preview_window = (10,50,window_width,window_height)
        self.camera.start_preview()
        self.camera.drc_strength = 'medium'
        
    # ................. end of method: start_camera .................


    #.................... Method: open_solenoids ................
    # This method actuates the solnoids to the ON state
    #
    def open_solenoids(self):
        GPIO.output(sol1_pin, True)
        GPIO.output(sol2_pin, True)
        status = ""
        status = "Solenoids are OPEN\n"
        self.results_txt.delete(0.0,END)
        self.results_txt.insert(0.0, status)      
    # ................. end of method: open_solenoids .................


    #.................... Method: close_solenoids ................
    # This method actuates the solnoids to the OFF state
    #
    def close_solenoids(self):
        GPIO.output(sol1_pin, False)
        GPIO.output(sol2_pin, False)
        status = ""
        status = "Solenoids are CLOSED\n"
        self.results_txt.delete(0.0,END)
        self.results_txt.insert(0.0, status)
    # ................. end of method: close_solenoids ................

    #.................... Method: pump_on ................
    # This method actuates the solnoids to the OFF stateturns the micro pump ON
    #
    def pump_on(self):
        GPIO.output(pump_pin, True)
        status = ""
        status = "Pump is ON\n"
        self.results_txt.delete(0.0,END)
        self.results_txt.insert(0.0, status)
    # ................. end of method: pump_on ................

    #.................... Method: pump_off ................
    # This method actuates the solnoids to the OFF stateturns the micro pump ON
    #
    def pump_off(self):
        GPIO.output(pump_pin, False)
        status = ""
        status = "Pump is OFF\n"
        self.results_txt.delete(0.0,END)
        self.results_txt.insert(0.0, status)
    # ................. end of method: pump_off ................

    #.................... Method: read_pressure ................
    # This method reads pressure values from the MCP3008 ADC
    #
    def read_pressure(self):
        channel1 = 0
        channel2 = 1
        r1 = spi.xfer2([1, (8+channel1) <<4, 0])
        r2 = spi.xfer2([1, (8+channel2) <<4, 0])
        adc1_out = ((r1[1]&3) << 8) + r1[2]
        adc2_out = ((r2[1]&3) << 8) + r2[2]
        adc1_out = format((int(adc1_out) - b) / m, '.2f')
        adc2_out = format((int(adc2_out) - b) / m, '.2f')
        press1.set(str(adc1_out) + ' PSI')
        press2.set(str(adc2_out) + ' PSI')
        root.after(1000, self.read_pressure)
    # ................. end of method: read_pressure ................


# stepper motor counter clockwise function
def motor_ccw(steps,speed):
    GPIO.output(DIR_PIN, True)
    usDelay = 1/speed * 70.0
    sDelay  = usDelay * (1E-6)
    for i in range(steps):
        GPIO.output(STEP_PIN,True)
        sleep(sDelay)
        GPIO.output(STEP_PIN, False)
        sleep(sDelay)
      
# stepper motor clockwise function  
def motor_cw(steps,speed):
    GPIO.output(DIR_PIN, False)
    usDelay = 1/speed * 70.0
    sDelay  = usDelay * (1E-6)
    for i in range(steps):
        GPIO.output(STEP_PIN,True)
        sleep(sDelay)
        GPIO.output(STEP_PIN, False)
        sleep(sDelay)      
        
        

wait_time = 1.5

def worker_function(steps, speed, wait_time, quit_flag):
    counter = 0
    while not quit_flag.value:
        counter += 1
        logging.info("Work # %d" % counter)
        motor_ccw(steps, speed)
        sleep(wait_time)
        motor_cw(steps, speed)
        sleep(wait_time)
        

#=================================================================
# main
#=================================================================

format_log = '%(levelname)s: %(filename)s: %(lineno)d: %(message)s'
logging.basicConfig(level=logging.DEBUG, format=format_log)

root = Tk()                            # Create the GUI root object
press1 = StringVar()
press2 = StringVar()

root.title("miniDrops")

x = 275
y = 50
w = 580
h = 250


root.geometry('%dx%d+%d+%d' % (w, h, x, y))
app = Application(master = root)          # Create the root application window
quit_flag = multiprocessing.Value('i', int(False))               
root.after(0, app.read_pressure)
worker_thread=threading.Thread(target=worker_function, args=(950,0.265,3.5,quit_flag,))         # Stepper motor sitrring parameters (steps,speed,wait_time)
worker_thread.start()
logging.info("quit_flag.value = %s" % bool(quit_flag.value))

try:
    app.mainloop()
except:
    logging.info("Keyboard interrupt")
    
quit_flag.value = True
logging.info("quit_flag.value = %s" % bool(quit_flag.value))
worker_thread.join()
