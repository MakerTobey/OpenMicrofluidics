# Open resources of interest for testing and further development

Any contribution and participation welcome! I am happy to connect and perhaps even help with resources, parts and funding! Comment here or write to tobias.wenzel@embl.de

## Selected promising resources

### Open syringepump(s)
http://www.appropedia.org/Open-source_syringe_pump
http://www.appropedia.org/Lynch_open_source_syringe_pump_modifications

### Open pressure controll (alternative to syringe pumps)

My own project, to be extended and tested: https://www.docubricks.com/viewer.jsp?id=6067044959053384704
A useful manifold for quake-style valves, to be tested soon: https://metafluidics.org/devices/32-channel-controller/

### Open digital microscopy

Open Flexure Microscope
https://aip.scitation.org/doi/10.1063/1.4941068
https://www.docubricks.com/viewer.jsp?id=6067044959053384704
with objective:
https://github.com/rwb27/openflexure_microscope
with motorisation:
https://github.com/rwb27/openflexure_nano_motor_controller

FlyPi:
https://open-labware.net/projects/flypi/
https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.2002702

### Open Dropseq station and Open Digital PCR

After looking at the details of the project, this seems like a fantastic piece of hardware and documentation. We will definitely try to build it. Nice small and low-cost solutions for pressure controll.
https://metafluidics.org/devices/minidrops/
https://www.nature.com/articles/s41467-017-02659-x#Sec9

### Open fast-imaging solutions

None are konwn to us so far! Please let me know. Fast-responding cameras would be great or stroboscopic illumination for droplet microfluidics

I believe that stroboscopic imaging has already been build by many labs. Who would be interested to publish the designs openly?

Paper references of possible interest:
https://www.hindawi.com/journals/jamc/2009/198732/
https://aapt.scitation.org/doi/abs/10.1119/1.4863916
https://www.mdpi.com/2072-666X/8/12/351
https://www.future-science.com/doi/abs/10.2144/000112220
https://www.sciencedirect.com/science/article/pii/S0165027012003846
https://media.proquest.com/media/pq/classic/doc/4322030507/fmt/ai/rep/NPDF?_s=EUAbzVz%2B%2FEKGyiix9oguFSmtgAU%3D

Maybe:
https://pdfs.semanticscholar.org/63f0/b73d48380f3d5d3614e0fe12ae55adaeb1dd.pdf
https://www.spiedigitallibrary.org/conference-proceedings-of-spie/5145/0000/Simultaneous-mapping-of-phase-and-amplitude-of-MEMS-vibrations-by/10.1117/12.500138.short?SSO=1
https://scholar.google.de/scholar?hl=en&as_sdt=0%2C5&as_vis=1&q=stroboscopic%2Billumination%2Bmicroscope%2Barduino&btnG=
https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0143547
https://pubs.acs.org/doi/abs/10.1021/ja074704l

Open Source imaging chips:
https://wiki.apertus.org/index.php/Main_Page

Open Source imaging software:
https://www.osapublishing.org/boe/abstract.cfm?uri=boe-1-2-385


### Open Fluorescence Activated Droplet Sorting

FACS equivalent sorting of droplets for directed evolution and many other essays is a key method in microfluidics that only few labs master. One of the reasons is that few instructions are available (but they do exsist! See Christoph Merten in Nature Methods), and equipemnt is complex, propriatory and very expensive. A common work station for droplet sorting usually costs more than 100.000 Euro. Now, an open source version (no propriatory sorware and harware lock-in, modifiable, modular and extensible) comes within reach! These are the things needed:


This requires a strong lightsource (laser, most commonly 488nm, collimated, small elliptical focal spot, low coherence to avoid speckles) to activate fluorescence. Usually a few thousand Euro per laser and some additional hundred Euro for the optics (not counting a professional microscope)


It requires a fast and very sensitive detector for the fluorescent signal. This is commonly a PMT (photomultiplier tube), but now there are cheaper and less-easy-to-break APDs (avalanche photodiode)s. Individually they should cost in the order of magnitude of a hundred Euro, but they need to be hosted on a controller, cooling, etc. unit with appropriate connector, which usually spikes the cost to thousands. However, now there is work on an open source APD controller:
OpenAPD:

http://www.gaudi.ch/GaudiLabs/?page_id=718

https://ieeexplore.ieee.org/document/5158737


And then there is a need for a very fast real-time logical processor chip, which is usually achieved by programming an FPGA chip. This chip will read the signal and make a decision whether or not to activate the droplet sorter. (For example: Positive signal is coming in, intensity and duration (width) is in the right range and there was no other signal too shortly before, so OK, activate the amplifier trigger for the sorting electrode.) FPGAs are usually not exacly user friendly as they are programmed in a bottom-level hardware language. Easy-to-use systems (with integrated top level languages for programming and common measurement-tech interfaces) usually some in a propriatory environment and are very expensive. However, there has been a lot of activity in the respective open source landscape recently.

Medium cost, established for science measurements:

Red Pitaya https://www.redpitaya.com


One newer projects to make FPGAs accessible, still requires advanced electronics or programming knowledge:

http://www.clifford.at/icestorm/

https://hackaday.com/2018/12/13/icebreaker-the-open-source-development-board-for-fpgas/

http://papilio.cc (more light weight)


### Open digital microfluidics ... and other related

OpenDrop
http://www.gaudi.ch/GaudiLabs/?page_id=392
And Dropbot
http://microfluidics.utoronto.ca/dropbot/
