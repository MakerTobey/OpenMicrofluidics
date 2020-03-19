This is a fork of the [OpenFlexure Microscope](https://github.com/rwb27/openflexure_microscope) pre-release [beta 5.20](https://github.com/rwb27/openflexure_microscope/releases/tag/v5.20.0-b).
The [corresponding build instructions live here](http://rwb27.github.io/openflexure_microscope/docs/).

In this repository, the design is beeing modified for fluorescence application and additional photosensors for FADS.
The official [discussion on a fluorescence version of the OpenFlexure Microscope takes place here](https://github.com/rwb27/openflexure_microscope/issues/43).
Relevant [illumination parts (Kohler illumination, condenser) are discussed here](https://github.com/rwb27/openflexure_microscope/issues/77).

# OpenFlexture Fluorescence Microscope
## This build is a fork of the Open Flexture Microscope version 6.0

FOr strong fluorescnece stimulation, we use a high-power LED solution, based the illumination used here: https://pubs.acs.org/doi/10.1021/acs.analchem.7b04689

We purchased the folloing from Luxeonstar.com (February 2019):

Part Nr | Description | Price
--- | --- | ---
SP-01-B6 | LED: Blue (470nm) Rebel LED (LXML-PB02) on a SinkPAD-II 20mm Star Base - 74lm @ 700mA  | 13.08 $US
10193 | Carclo 8.7° 20 mm Circular Beam Optic - No Holder | 2.60 $US
10235 | Carclo 20 mm Black Round Optic Holder - Flat Bottom | 0.70 $US
LXT-S-12 | Pre-Cut, Thermal Adhesive Tape for 20 mm Star LED Assemblies - (12 Piece Sheet)| 7.49 $US
N30-10B | 30 mm Square x 10 mm High Alpha Heat Sink - 14.0 °C/W 10193 Carclo 8.7° 20 mm Circular Beam Optic - No Holder | 5.72 $US
LP-01 | Assembly Press for Mounting Single Rebel LED Assemblies to a Heatsink | 0.00 $US
shipping | Shipping to Europe | 21.01 $USD

## optical filters

The filters from [Comar Optics (UK)](https://www.comaroptics.com/components/filters) seem to have a good price range. I ordered the following filters to integrate into the [Open Flexturescope](https://github.com/rwb27/openflexure_microscope/issues/43). I ordered the parts in March 2019 and more January 2020.

Part Nr | Description | Price in GBP
--- | --- | ---
495 IK 116 | (Excitation filter, Shortpass 495) Dichroic filter, 25 x 16 x 1.1mm | £21.34
550 IY 125 | (Dichroic beam splitter, Longpass 506) Dichroic filter, 50 x 50 x 1.1mm | £47.19
510 IY 50 | (Emission filter, Longpass 519) Dichroic filter, 50 x 50 x 1.1mm | £47.19
--- | --- | ---
525 IB 25 | Dichroic filter, band pass, 500/550nm, dia 25mm x 1mm | £26.07
585 AY 25 | Acrylic colour filter, 585nm longpass, 25mm diameter x 1mm | £9.24
635 IY 125 | Dichroic filter, long pass, 635nm, 40 x 25 x 1.1mm | £38.24
40 BA 00 | Plate beamsplitter, standard, visible 50%, 40mm diameter x 3mm(thick!) | £37.07

Shipping with Comar Priority Service to Germany - £24.65

The first three filters form a GFP, Fluorescine etc. standard fluorescence set. The later filters can extend the stack to Propidium Iodite (PI) filtering in the yellow fraction of the spectrum.

### Related aspects to this projects are beeing discussed on the [Open FADS part of this repository](https://github.com/MakerTobey/OpenMicrofluidics/tree/master/Open%20Fluorescence%20Activated%20Droplet%20Sorting%20(FADS)).
