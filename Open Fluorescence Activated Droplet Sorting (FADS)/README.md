# Open Fluorescence Activated Droplet Sorting (Open FADS)

FACS (Fluorescence Activated Cell Sorting) equivalent sorting of droplets for directed evolution and many other essays is a key method in microfluidics that only few labs master. One of the reasons is that few instructions are available (but they do exsist! See Christoph Merten in Nature Methods), and equipemnt is complex, propriatory and very expensive. A common work station for droplet sorting usually costs ca. 100.000 Euro. Now, an open source version (no propriatory sorware and harware lock-in, modifiable, modular and extensible) comes within reach! 

The current focus of this project is the FPGA data processing, which is worked on in this repository: https://github.com/MakerTobey/Open_FPGA_control_for_FADS


# These are the things needed for a FADS workstation:

## light source
This requires a strong lightsource (laser, most commonly 488nm {for Green Fluorescent Protein (GFP), red RFP and similar}, collimated, small elliptical focal spot, low coherence to avoid speckles) to activate fluorescence. Lasers usually cost several thousand Euro but some cheaper ones are available at slightly different wavelengths https://www.dragonlasers.com/blue-laser-pointers.html. Usually one has to calculate with a few thousand Euro per laser and some additional hundred Euro for the optics (not counting a professional microscope). Here we explore how to keep costs reasonably low while maintaining the quality and specifications of the setup.

## fast and sensitive fluorescence detection
It requires a fast and very sensitive detector for the fluorescent signal. This is commonly a PMT (photomultiplier tube), but now there are cheaper and less-easy-to-break APDs (avalanche photodiode)s. Individually they should cost in the order of magnitude of a hundred Euro, but they need to be hosted on a controller, cooling, etc. unit with appropriate connector, which usually spikes the cost to thousands. However, now there is work on an open source APD controller:
OpenAPD:

http://www.gaudi.ch/GaudiLabs/?page_id=718

Some circuits (e.g. amplification) might be useful from the CosmicPi projekt:

https://github.com/CosmicPi/CosmicPiV1.6PCB

https://ieeexplore.ieee.org/document/5158737


## fast data processing
And then there is a need for a very fast real-time logical processor chip, which is usually achieved by programming an FPGA chip. This chip will read the signal and make a decision whether or not to activate the droplet sorter. (For example: Positive signal is coming in, intensity and duration (width) is in the right range and there was no other signal too shortly before, so OK, activate the amplifier trigger for the sorting electrode.) FPGAs are usually not exacly user friendly as they are programmed in a bottom-level hardware language. Easy-to-use systems (with integrated top level languages for programming and common measurement-tech interfaces) usually some in a propriatory environment and are very expensive. However, there has been a lot of activity in the respective open source landscape recently.

Medium cost, established for science measurements:

Red Pitaya https://www.redpitaya.com This has been now purchased for testing from Reichelt Electronik (reichelt.de, January 2019):

Part Nr | Description | Price
--- | --- | ---
STEMLAB 14 UK | we bought this complete kit: USB-Messlabor STEMlab 125-14 Ultimate Kit, 2 Kanäle, 50 MHz, USB | 624,00 EUR 
STEMLAB 14 SK | But this unit would have been sufficient: USB-Messlabor STEMlab 125-14 Starter Kit, 2 Kanäle, 50 MHz, USB | 308.00 EUR
shipping | shipping | 5.60 EUR

Newer projects to make FPGAs accessible, still require advanced electronics or programming knowledge:

http://www.clifford.at/icestorm/ https://media.ccc.de/v/32c3-7139-a_free_and_open_source_verilog-to-bitstream_flow_for_ice40_fpgas

https://hackaday.com/2018/12/13/icebreaker-the-open-source-development-board-for-fpgas/

http://papilio.cc (more light weight)

The processing is currently beeing worked on using the Red Pitaya as a platform. This work is hosted in this seperate repository https://github.com/MakerTobey/Open_FPGA_control_for_FADS


## high voltage AC pulse generation for dielectrophoretic droplet movement

Here is an estimate of the specs that are beeing used for high-end droplet sorting:

A voltage of ca. 0.1-3kV (at quasi zero Ampere current) is applied to the electrodes on chip. This depends quite a lot on the electrode geometry and the forces required. Using longer electrodes (Rails etc.) Sub 1kV voltages are sufficient (see "Rational design of a high-throughput droplet sorter" Lab on a Chip 2019, DOI: 10.1039/c9lc00149b https://pubs.rsc.org/en/content/articlelanding/2019/LC/C9LC00149B#!divAbstract)

0.4-3 milisecond (ms) pulses sent to the electrodes on chip (depending on droplet size, speed and electrode shape). This needs to happen with usually no more than a 100us delay after detecting the fluorescent signal, as the drops move fast.

The pulse itself is then still alternating current (AC), with a frequency of ca. 0.1-40kHz frequency (generalisation: the higher the frequency in these limits, the stronger is the force on the droplet). Starting value here: 20kHz or higher. *Question: How can this value be smaller or equal the droplet sorting rate?*

Apparently [square wave (DC-DC) pulses are more efficient for dielectrophoresis than AC waves](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=2ahUKEwiIjt2c94HhAhWHZ1AKHfeSCYYQFjABegQIABAC&url=https%3A%2F%2Ftigerprints.clemson.edu%2Fcgi%2Fviewcontent.cgi%3Farticle%3D1016%26context%3Dmecheng_pubs&usg=AOvVaw1J-VG6QFMguafNriVgkh64). This is also what most people in the field (who mention it) seem to use if they can. Generating these signals is not so hard - there are many decent small, open and cheap function generators. This can also easily be done on the same FPGA computer that is already used for data processing.

However, amplification of these pulses is hard and there seem to be only two equipment providers (Trek and Matsusada). The amplifiers are expensive (ca. 5-10 kEuro), large, heavy and energy consuming.

However, since we only need a square wafe signal with stable levels, there seems to be an opportunity to build a switch chip using with voltage power converter units (e.g. APS models from ISEG https://iseg-hv.com/en/products/dc-dc) and voltage tollerant MOSFETs (e.g. https://de.rs-online.com/web/p/mosfet/8016794/).
