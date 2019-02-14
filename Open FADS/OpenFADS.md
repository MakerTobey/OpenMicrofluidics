# Open Fluorescence Activated Droplet Sorting (Open FADS)

FACS (Fluorescence Activated Cell Sorting) equivalent sorting of droplets for directed evolution and many other essays is a key method in microfluidics that only few labs master. One of the reasons is that few instructions are available (but they do exsist! See Christoph Merten in Nature Methods), and equipemnt is complex, propriatory and very expensive. A common work station for droplet sorting usually costs ca. 100.000 Euro. Now, an open source version (no propriatory sorware and harware lock-in, modifiable, modular and extensible) comes within reach! These are the things needed:

## light source
This requires a strong lightsource (laser, most commonly 488nm {for Green Fluorescent Protein (GFP), red RFP and similar}, collimated, small elliptical focal spot, low coherence to avoid speckles) to activate fluorescence. Usually a few thousand Euro per laser and some additional hundred Euro for the optics (not counting a professional microscope). Here we explore the use of much cheaper and more accessible high-power LED solutions, based the illumination used here: https://pubs.acs.org/doi/10.1021/acs.analchem.7b04689

We purchased the folloing from Luxeonstar.com (February 2019):
Part Nr | Description | Price
--- | --- | ---
SP-01-B6 | LED: Blue (470nm) Rebel LED (LXML-PB02) on a SinkPAD-II 20mm Star Base - 74lm @ 700mA  | 13.08 $US
10193 | Carclo 8.7° 20 mm Circular Beam Optic - No Holder | 2.60 $US
10235 | Carclo 20 mm Black Round Optic Holder - Flat Bottom | 0.70 $US
LXT-S-12 | Pre-Cut, Thermal Adhesive Tape for 20 mm Star LED Assemblies
- (12 Piece Sheet)| 7.49 $US
N30-10B | 30 mm Square x 10 mm High Alpha Heat Sink - 14.0 °C/W 10193 Carclo 8.7° 20 mm Circular Beam Optic - No Holder | 5.72 $US
LP-01 | Assembly Press for Mounting Single Rebel LED Assemblies to a Heatsink | 0.00 $US
| Shipping to Europe | 21.01 $USD

## fast and sensitive fluorescence detection
It requires a fast and very sensitive detector for the fluorescent signal. This is commonly a PMT (photomultiplier tube), but now there are cheaper and less-easy-to-break APDs (avalanche photodiode)s. Individually they should cost in the order of magnitude of a hundred Euro, but they need to be hosted on a controller, cooling, etc. unit with appropriate connector, which usually spikes the cost to thousands. However, now there is work on an open source APD controller:
OpenAPD:

http://www.gaudi.ch/GaudiLabs/?page_id=718

https://ieeexplore.ieee.org/document/5158737

## fast data processing
And then there is a need for a very fast real-time logical processor chip, which is usually achieved by programming an FPGA chip. This chip will read the signal and make a decision whether or not to activate the droplet sorter. (For example: Positive signal is coming in, intensity and duration (width) is in the right range and there was no other signal too shortly before, so OK, activate the amplifier trigger for the sorting electrode.) FPGAs are usually not exacly user friendly as they are programmed in a bottom-level hardware language. Easy-to-use systems (with integrated top level languages for programming and common measurement-tech interfaces) usually some in a propriatory environment and are very expensive. However, there has been a lot of activity in the respective open source landscape recently.

Medium cost, established for science measurements:

Red Pitaya https://www.redpitaya.com This has been now purchased for testing from Reichelt Electronik (reichelt.de, January 2019):
Part Nr | Description | Price
--- | --- | ---
STEMLAB 14 UK | we bought this complete kit: USB-Messlabor STEMlab 125-14 Ultimate Kit, 2 Kanäle, 50 MHz, USB | 624,00 EUR 
STEMLAB 14 SK | But this unit would have been sufficient: USB-Messlabor STEMlab 125-14 Starter Kit, 2 Kanäle, 50 MHz, USB | 308.00 EUR
| shipping | 5.60 EUR

One newer projects to make FPGAs accessible, still requires advanced electronics or programming knowledge:

http://www.clifford.at/icestorm/ https://media.ccc.de/v/32c3-7139-a_free_and_open_source_verilog-to-bitstream_flow_for_ice40_fpgas

https://hackaday.com/2018/12/13/icebreaker-the-open-source-development-board-for-fpgas/

http://papilio.cc (more light weight)

## high voltage AC pulse generation for droplet movement
We do not have an open source (and ideally low cost) solution for this yet. Please point us to solutions if you know any!
