# Open Source Microfluidics Hardware

This GitHub repository is an in-progress collection of Open Source Hardware instrumentation for microfluidics and ultra-high troughput lifescience experimentation research. This is a community driven effort and **you are invited to contribute thoughts, content, comments and help testing the instrumentation**! 

This projekt started as part of my current Fellowship Freies Wissen (translates to Open Knowledge), here is the [project description on the corresponding Wikiversity page](https://de.wikiversity.org/wiki/Wikiversity:Fellow-Programm_Freies_Wissen/Einreichungen/Open_labware_for_better_life_science). And is beeing further developed as part of my reseach efforts as well as in my free time, togehter with various project partners.

## The following two aims are addressed in this repository:

* A review outline that collects information on the openess of the research field, its instrumentation and reagents. **Please comment by submitting issues on GitHub or contact me directly** if you want to be part of the more concentrated writing effort: Tobias.Wenzel /at/ embl.de

* A list of microfluidics relevant Open Source Harwdare instrumentation, connected to the practical aim of testing the documentations by reading them carefully, by building the instrumentation in some cases (remotely and Heidelberg based workshop in early 2019) and further by testing, comparing and calibrating the equipement. **Everyone is welcome to contribute**.  Please contact me directly (Tobias.Wenzel /at/ embl.de) if you need financial help with hardware parts in oder to test the documentations and redocument them on [DocuBricks](docurbricks.com) to create more accessible, open hardware standard documentations.

### Happy contributing!

# Openess of microfluidics research & developement and ways forward

Increasing openess can be acheived in many different ways, such as increased accessibility of techniques or results to a professional or general audience, greater ease of use, increased mobility of researchers of different seniority, discipines or ethnicity into the field.
One aspect that enjoys recent popularity in microfluidic and bioprocess technologies is the "biohacker"or Do-It-Yourself (DIY) biology movement. The later includes self-made and low-cost research instrumentation.
Such advances in openess greatly improve the accessibility of microfluidic and related technology to lay people and have been reviewed recently [akerspaces." Trends in Biotechnology (February 3, 2017). https://doi.org/10.1016/j.tibtech.2017.01.001].
The open source hardware originating from this context does usually not, however, fulfill key application relevant criteria such as basic safety mechanisms (e.g. dremel fuge), bencharking calibration assessment (e.g. XXX), and documentation best practices as reccomended by the GOSH community [e.g. https://www.docubricks.com/best-practise-guide.jsp] or the Journal of Open Hardware, OSWA, etc.
For the above reasond of focus and qality management, here we focus on hardware and manufacturing related aspects of microfluidic and related technology for professional (in particular academic) applications.
In particular we probe 

(I) the use of open platforms and software.

(II) digitalisation and use/challenges of digital manufacturing

(III) identification of potentially valualble resources for microfluidic research drawing on digital manufacturing, open source and publis resources.
* high quality small-scale fluidic chip manufacturing techniques
* imaging of droplets (normal, fhigh-speed (e.g. stroboscopic+software), fluorescence)
* sorting of droplets (hardware-fast-processing, software, instructions)
* pressure control
* simlation tools
* open reagents 


# Free and Open Source Hardware resources of interest for testing and further development - selected promising resources

Any contribution and participation welcome! I am happy to connect and perhaps even help with resources, parts and potential parts-funding! Comment here, via issues, or email me.

## Open Dropseq station and Open Digital PCR

After looking at the details of the project, this seems like a fantastic piece of hardware and documentation. We will definitely try to build it and have already ordered all parts. Nice small and low-cost solutions for pressure controll. Parts are being purchased at the moment. Please look into the respective sub-repository: 

https://github.com/MakerTobey/OpenMicrofluidics/tree/master/Minidrop%20build%20and%20test

https://metafluidics.org/devices/minidrops/
https://www.nature.com/articles/s41467-017-02659-x#Sec9

### Open Fluorescence Activated Droplet Sorting

This is an active contsturction project! For files and progress, please look into the respective folder in this repository: https://github.com/MakerTobey/OpenMicrofluidics/tree/master/Open%20Fluorescence%20Activated%20Droplet%20Sorting%20(FADS)

FACS (Fluorescence Activated Cell Sorting) equivalent sorting of droplets for directed evolution and many other essays is a key method in microfluidics that only few labs master. One of the reasons is that few instructions are available (but they do exsist! See Christoph Merten in Nature Methods), and equipemnt is complex, propriatory and very expensive. A common work station for droplet sorting usually costs ca. 100.000 Euro. Now, an open source version (no propriatory sorware and harware lock-in, modifiable, modular and extensible) comes within reach!

## Open microfluidics pressure control

### Open syringepump(s)

http://www.appropedia.org/Open-source_syringe_pump
We have built two, but will further upgrade and test.

http://www.appropedia.org/Lynch_open_source_syringe_pump_modifications
https://www.sciencedirect.com/science/article/pii/S2468067218300269

We are building and testing some of this hardware! Please look into the respective project subfolder: https://github.com/MakerTobey/OpenMicrofluidics/tree/master/pressure%20control%20build%20and%20test

### Open pressure controll

My own project to build an ardunino based 2-channel pressure controll (pressure derived from a compressor), to be extended and tested: https://www.docubricks.com/viewer.jsp?id=6067044959053384704 Also explore our seperate GitHub repository: https://github.com/MakerTobey/uFluid

This project looks similar and deserves further attention: https://hackaday.io/project/148274-electronic-pressure-regulator, https://github.com/watsaig/ufcs-pc

A useful manifold for quake-style valves, already build and soon to be tested: https://github.com/GNHua/valve-control

Another useful manifold for quake-style valves, to be tested soon: https://metafluidics.org/devices/32-channel-controller/ Is this documentation incomplete?

In this project and with colleagues, we are following up on thiese hardware pieces. The Minidrop station includes another curstom pressure controll implementation.

## Open digital microfluidics ... and other related

OpenDrop
http://www.gaudi.ch/GaudiLabs/?page_id=392

And Dropbot
http://microfluidics.utoronto.ca/dropbot/

## Open digital microscopy

Open Flexure Microscope
https://aip.scitation.org/doi/10.1063/1.4941068
https://www.docubricks.com/viewer.jsp?id=6067044959053384704
with objective:
https://github.com/rwb27/openflexure_microscope
with motorisation:
https://github.com/rwb27/openflexure_nano_motor_controller
We are currently waiting for the new release (large, with automation and objective) to build one.

FlyPi:
https://open-labware.net/projects/flypi/
https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.2002702


## Open fast-imaging solutions

No microfluidics related fast imaging open hardware projects are konwn to us so far! Please let me know if you are aware of a resource. Fast-responding cameras would be great or stroboscopic illumination for droplet microfluidics.

I believe that stroboscopic imaging has already been build by many labs. Who would be interested to publish the designs openly?

Paper references of possible interest:
https://www.hindawi.com/journals/jamc/2009/198732/
https://aapt.scitation.org/doi/abs/10.1119/1.4863916
https://www.mdpi.com/2072-666X/8/12/351
https://www.future-science.com/doi/abs/10.2144/000112220
https://www.sciencedirect.com/science/article/pii/S0165027012003846
This link is broken at the moment! What content was here?  -> https://media.proquest.com/media/pq/classic/doc/4322030507/fmt/ai/rep/NPDF?_s=EUAbzVz%2B%2FEKGyiix9oguFSmtgAU%3D

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
