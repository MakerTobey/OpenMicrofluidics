FACS (Fluorescence Activated Cell Sorting) equivalent sorting of droplets for directed evolution and many other essays is a key method in microfluidics that only few labs master. One of the reasons is that few instructions are available (but they do exsist! See Christoph Merten in Nature Methods), and equipemnt is complex, propriatory and very expensive. A common work station for droplet sorting usually costs ca. 100.000 Euro. Now, an open source version (no propriatory sorware and harware lock-in, modifiable, modular and extensible) comes within reach! These are the things needed:


This requires a strong lightsource (laser, most commonly 488nm {for Green Fluorescent Protein (GFP) and similar}, collimated, small elliptical focal spot, low coherence to avoid speckles) to activate fluorescence. Usually a few thousand Euro per laser and some additional hundred Euro for the optics (not counting a professional microscope).


It requires a fast and very sensitive detector for the fluorescent signal. This is commonly a PMT (photomultiplier tube), but now there are cheaper and less-easy-to-break APDs (avalanche photodiode)s. Individually they should cost in the order of magnitude of a hundred Euro, but they need to be hosted on a controller, cooling, etc. unit with appropriate connector, which usually spikes the cost to thousands. However, now there is work on an open source APD controller:
OpenAPD:

http://www.gaudi.ch/GaudiLabs/?page_id=718

https://ieeexplore.ieee.org/document/5158737


And then there is a need for a very fast real-time logical processor chip, which is usually achieved by programming an FPGA chip. This chip will read the signal and make a decision whether or not to activate the droplet sorter. (For example: Positive signal is coming in, intensity and duration (width) is in the right range and there was no other signal too shortly before, so OK, activate the amplifier trigger for the sorting electrode.) FPGAs are usually not exacly user friendly as they are programmed in a bottom-level hardware language. Easy-to-use systems (with integrated top level languages for programming and common measurement-tech interfaces) usually some in a propriatory environment and are very expensive. However, there has been a lot of activity in the respective open source landscape recently.

Medium cost, established for science measurements:

Red Pitaya https://www.redpitaya.com This has been now purchased for testing.


One newer projects to make FPGAs accessible, still requires advanced electronics or programming knowledge:

http://www.clifford.at/icestorm/ https://media.ccc.de/v/32c3-7139-a_free_and_open_source_verilog-to-bitstream_flow_for_ice40_fpgas

https://hackaday.com/2018/12/13/icebreaker-the-open-source-development-board-for-fpgas/

http://papilio.cc (more light weight)

