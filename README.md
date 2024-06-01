

![balena OGN Glider Tracker](https://raw.githubusercontent.com/ketilmo/balena-ogn/master/docs/images/header.png)

**Feed the glider traffic in your area to the Open Glider Network (OGN) using a Raspberry Pi 3 or 4 with balena!**


Tracking commercial aircraft has long become commonplace through popular services such as [FlightAware](https://flightaware.com/), [Flightradar24](https://www.flightradar24.com/), and [Plane Finder](https://planefinder.net/). Smaller soaring aircraft such as gliders, paragliders, and drones are not equipped with ADS-B transponders, however, and have been impossible to track.

With [Open Glider Network (OGN)](http://wiki.glidernet.org/) and syndicator sites such as [Spot the Gliders](https://live.glidernet.org/), [GliderRadar](https://www.gliderradar.com/), [GliderTracker](https://glidertracker.de/), [PureTrack.io](https://puretrack.io/), and [Glide and Seek](https://glideandseek.com/), that's changing. OGN is a community-powered service that tracks smaller aircraft using lightweight beacon technology such as FLARM, FANET, and ADS-L.

Sounds fun? To start feeding data to Open Glider Network and [OpenSky Network](https://opensky-network.org/), you need a Raspberry Pi, an [RTL-SDR](https://www.rtl-sdr.com/) USB stick, and an antenna—together with the code and instructions below. 

# Stay in the loop

👉🏻&nbsp;<a href="https://buttondown.email/balena-ads-b"> Subscribe to our newsletter</a>&nbsp;👈🏻&nbsp; to stay updated on the latest development of this project and its sister project [balena ADS-B Flight Tracker](https://github.com/ketilmo/balena-ads-b).

# Got stuck? Get help!

💬&nbsp; [Ask a question](https://github.com/ketilmo/balena-ogn/discussions) in our discussion board

✏️&nbsp; [Create a post](https://forums.balena.io/t/the-balena-ogn-thread/370478) in our balena forum thread

🚨&nbsp; [Raise an issue](https://github.com/ketilmo/balena-ogn/issues) on GitHub

📨&nbsp; [Reach out directly](https://ketil.mo.land/contact)

🗞&nbsp; [Read past newsletters](https://buttondown.email/balena-ads-b/archive/)

# Supported devices
<table>
<tr><td>
<img height="24px" src="https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/arch/intel-nuc.svg" alt="intel-nuc" style="max-width: 100%; margin: 0px 4px;"></td><td>Intel NUC</td>
</tr>
<tr><td>
<img height="24px" src="https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/arch/jetson-nano-2gb-devkit.svg" alt="jetson-nano-2gb-devkit" style="max-width: 100%; margin: 0px 4px;"></td><td>Nvidia Jetson Nano 2GB Devkit SD</td>
</tr>
<tr><td>
<img height="24px" src="https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/arch/raspberrypi3.svg" alt="raspberrypi3" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 3 Model B+</td>
</tr>
<tr><td>
<img height="24px" src="https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/arch/raspberrypi3-64.svg" alt="raspberrypi3-64" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 3 (using 64bit OS)</td>
</tr>
<tr><td>
<img height="24px" src="https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/arch/raspberrypi4-64.svg" alt="raspberrypi4-64" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 4 (using 64bit OS)</td>
</tr>
<tr><td>
<img height="24px" src="https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/arch/raspberrypi5.svg" alt="raspberrypi5" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 5</td>
</tr>
</table>

Please [let us know](https://github.com/ketilmo/balena-ogn/discussions/new) if you are successfully running **balena-ogn** on a hardware platform not listed here!

# Credits

The balena-ogn project was created and is maintained by [Ketil Moland Olsen](https://github.com/ketilmo/). It is based on the splendid [ogn-pi34](https://github.com/VirusPilot/ogn-pi34) repository maintained by the one and only [VirusPilot](https://github.com/VirusPilot). Thank you kindly for your excellent work! Improvements and refactoring by [Meisterschueler](https://github.com/Meisterschueler). Thanks! And big kudo goes to the team behind Open Glider Network for making it all possible.

Software packages downloaded, installed, and configured by the balena-ogn script are disclosed in [CREDITS.md](https://github.com/ketilmo/balena-ogn/blob/master/CREDITS.md).

# Contributors
<a href="https://github.com/ketilmo/balena-ogn/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ketilmo/balena-ogn" />
</a>

# Table of Contents
- [Part 1 – Build the receiver](#part-1---build-the-receiver)
- [Part 2 – Initial setup](#part-2---initial-setup)
- [Part 3 – Configuration](#part-3---configuration)
  * [Adding configuration variables](#adding-configuration-variables)
  * [Naming your station](#naming-your-station)
    + [Naming convention for airports](#naming-convention-for-airports)
    + [Naming convention for other locations](#naming-convention-for-other-locations)
    + [Optional postfix](#optional-postfix)
    + [Common mistakes](#common-mistakes)
    + [Exceptions for the UK](#exceptions-for-the-uk)
    + [Set your station name](#set-your-station-name)
  * [Set station location](#set-station-location)
- [Part 4 – Combining OGN and ADS-B feeding](#part-4---combining-ogn-and-ads-b-feeding)
- [Part 5 – Advanced configuration](#part-5---advanced-configuration)
  * [SDR PPM calibration](#sdr-ppm-calibration)
  * [Feeding to OpenSky Network](#feeding-to-opensky-network)
  * [Changing WiFi network](#changing-wifi-network)
  * [Disabling specific services](#disabling-specific-services)
- [Part 6 – Updating to the latest version](#part-6---updating-to-the-latest-version)

# Part 1 – Build the receiver
In its most minimal configuration, the receiver can be built using three core components: A currently supported [device](https://thepihut.com/products/raspberry-pi-4-model-b?variant=20064052674622) (see the [complete list](#supported-devices) above), a good [RTL-SDR USB dongle](https://thepihut.com/products/rtl-sdr-blog-v3-usb-dongle-with-dipole-antenna-kit) and an [868 MHz](https://store.rakwireless.com/products/fiber-glass-antenna?variant=41100821921990) (for Europe, Africa, and New Zealand) or [915 MHz](https://store.rakwireless.com/products/fiber-glass-antenna?variant=39705894813894) (for USA and Australia) antenna. In addition, you would need a [power supply](https://thepihut.com/products/raspberry-pi-27w-usb-c-power-supply?variant=42531604136131) for the device, an [SD card](https://thepihut.com/products/sandisk-microsd-card-class-10-a1) to install the operating system on, an [antenna cable](https://store.rakwireless.com/products/pulsar-cable-rak9731-rak9733?variant=39677580968134), and – depending on your choice – an [SMA adapter](https://store.rakwireless.com/products/sma-adapter). If you don't have it already, you'll need a [SD card reader](https://thepihut.com/products/mini-usb-c-microsd-card-reader), too. Although not strictly necessary, a [case](https://thepihut.com/products/raspberry-pi-4-case) could be a good idea for the device.

Piecing together the pieces should be straightforward. For more information, including other antenna options, look at the official OGN [hardware docs](https://wiki.glidernet.org/ogn-receiver-hardware-and-software). (Remember: For balena-ogn to work, please go with a device from the [supported devices](#supported-devices) list.)



# Part 2 – Initial setup

On a high level, there are two ways to deploy **balena-ogn**. The easy way to get started is to simply click this button:

[![Deploy with button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/ketilmo/balena-ogn&defaultDeviceType=raspberrypi4-64)

It will take you through creating (or logging into an existing) balena account and deploying the solution to an SD card you insert into a computing device of your choice. When you finish, the new device will appear on the balena dashboard. Magic! When this is done, you can skip directly to [Part 3 – Configuration](#part-3--configuration).

If you want to have more granular control or maybe pair balena-ogn with its sister project **[balena-ads-b](https://github.com/ketilmo/balena-ads-b)**, you might want to walk through this manual procedure instead:

 1. [Create a free balena account](https://dashboard.balena-cloud.com/signup). You might be asked to upload your public SSH key during the process. If you don't have a public SSH key yet, you can [create one](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
 2. Sign in to balena and head to the [*Fleets*](https://dashboard.balena-cloud.com/fleets) panel.
 3. Create a fleet with the name of your choice for your device type. Please take note of the fleet name. Just so you know, you will need it later. In the dialogue that appears, pick a *Default Device Type* that matches your device. Specify the SSID and password if you want to use WiFi (and your device supports it). 
 4. balena will create an SD card image for you, which will download automatically after a few seconds. Flash the image to an SD card using balena's dedicated tool [balenaEtcher](https://www.balena.io/etcher/).
 5. Insert the SD card in your receiver, and connect it to your cabled network (unless you plan to use WiFi only and configured that in step 3). 
 6. Power up the receiver.
 7. From the balena dashboard, navigate to the fleet you created. A new device with an automatically generated name should appear within a few minutes. Click on it to open it.
 8. You can rename your device to your taste by clicking on the pencil icon next to the current device name.
 9. Almost there! Next, we will push the **balena-ogn** code to your device through the balena cloud. We'll do that using the [balena CLI](https://github.com/balena-io/balena-cli). Follow the [official instructions](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md) to download and install the CLI for your operating system of choice.
 10. After installing the balena-cli, head into your terminal and log in to balena with the following command: `balena login`. Then, follow the instructions on the screen.
 11. Clone the balena-ads-b repository to your local computer: `git clone git@github.com:ketilmo/balena-ogn.git`. You can also fork the repo if you want to make changes to it.
 12. Head into the folder of the newly cloned repo by typing `cd balena-ogn`.
 13. Do you remember your fleet name from earlier? Good. Now, we are ready to push the applications to balena's servers by typing `balena push YOUR–FLEET–NAME–HERE`.
 14. Now, wait while the Docker containers build on balena's servers. If the process is successful, you will see a beautiful piece of ASCII art depicting a unicorn right in your terminal window:
<pre>
			    \
			     \
			      \\
			       \\
			        >\/7
			    _.-(6'  \
			   (=___._/` \
			        )  \ |
			       /   / |
			      /    > /
			     j    < _\
			 _.-' :      ``.
			 \ r=._\        `.
			<`\\_  \         .`-.
			 \ r-7  `-. ._  ' .  `\
			  \`,      `-.`7  7)   )
			   \/         \|  \'  / `-._
			              ||    .'
			               \\  (
			                >\  >
			            ,.-' >.'
			           <.'_.''
			             <'

</pre>
 15. Wait a few moments while the Docker containers are deployed and installed on your device. The groundwork is now done – good job!

# Part 3 – Configuration
With your device installed and ready, the next step is to go ahead and configure it. One of the neat features of balena is that all configuration lives in variables that can easily be added through balena's dashboard. Below, we'll go through the concept of adding these variables.

## Adding configuration variables
Configuration variables are core to balena, and we'll add quite a few during the setup. The procedure is simple:
1. Open the balena console and the [*Fleets*](https://dashboard.balena-cloud.com/fleets) panel. Then, click on the device you created earlier. 
2. Click on the _Device Variables_-button on the left-hand side of the screen.
3. Click on the blue _Add variable_-button on the upper left-hand side of the screen.
4. Select _Service_ as specified in the instructions (below), and type in the variable _Name_ and _Value_ as specified.
5. Click the _Add_ button.
6. Add more variables if desired, repeating steps 3 to 5.
7. When done, commit the changes to balena by clicking the _Apply all changes_ button on the lower left-hand side of the screen. (Alternatively, revert the changes by clicking the red _Revert all changes_ button.)
8. balena will now restart the services you have configured. Within a minute or two, everything should be operational.

## Naming your station
Your OGN station will need a unique name to connect to the OGN services. The name will need to follow the [OGN naming convention](http://wiki.glidernet.org/receiver-naming-convention), and should have

 - Minimum 3 characters
 - Maximum 9 characters
 - Characters and numbers only (A-Z, a-z and 0-9)

### Naming convention for airports
If, and only if, your receiver is located at an airport or airfield, give it a 4-character ICAO code identifier. It is important to keep the identifier in **upper-case notation**, e.g.:

 - **LFLE**  (Challes-les-Eaux)  
 - **LFLG**  (Grenoble, Versoud)  
 - **LFLP**  (Annecy, Meythet)  
 - **EPZR**  (ZAR, Poland)

If there is no ICAO code identifier for the airport, use the name of the airport in the **CamelCase** naming convention, e.g.:

 - **Koenigsdf**  (Gliding Center Königsdorf, Bavaria)  
 - **Klippneck**  (Klippeneck, Germany)  
 - **BadWrshfn**  (Bad Wörishofen, Germany)

### Naming convention for other locations
For other locations than airports (cities, towns, private houses, etc..) please follow the **CamelCase** naming convention. In addition, it's recommended to choose a name corresponding to the closest "known" place (town, institute, mountain, etc.), e.g.:

 - **Cern**  (European Organization for Nuclear Research, Geneva, Switzerland)  
 - **Paris**
 - **Cluses**  (Receiver near Cluses, France)  
 - **LeNoiray**  
 - **Marmolada**  (Highest mountain of the dolomites, Italy)

### Optional postfix
If there is more than one receiver at a given location, you can use numbers **or** cardinal direction (N, W, S, E).

 - **HugeTown1**  
 - **HugeTown2**  
 - **MyTownN**  
 - **MyTownS**

### Common mistakes
 - A receiver is often located at the airport/airfield, so you don't need to mention this. (Bad: HoyaFlpl, EDLGTurm. Good: Hoya, EDLG.)
 - Don't use country codes in the name. (Bad: DEboetzow. Good: Boetzow.)
 - Don't use abbreviations too much. The maximum of 9 characters should be enough in most cases. (Bad: BOZ. Better: BergenOZ or BgOpZoom. Bad: Strass1. Better: Strassham.)
 - Choose a name you can google. (Bad: Something cryptic like hgrtl, HGC, KCCM, SFVWUG, flevonet2.)
 - Don't write out cardinal directions. (Bad: LSZKWest, UrySud. Good: LSZKW, UryS. Even better: LSZK, Ury.)

### Exceptions for the UK
In the UK, if a receiver is near a BGA turn point, it can be named UKXXX, where XXX is the BGA turn point, e.g. UKFOX. (**Note:** This does not have a dash.)

*Adapted from [wiki.glidernet.org](http://wiki.glidernet.org/receiver-naming-convention)*

### Set your station name
Have you been able to find the perfect name for your station that follows the naming convention? And checked with one of the OGN sites, such as [GliderRadar](https://www.gliderradar.com/) or [GliderTracker](https://glidertracker.de/), that it is not already taken? Perfect! Let's set that name in balena:

1. Set the receiver name by creating a [configuration variable](#adding-configuration-variables) for the service _ogn_ with the name `OGN_CALLSIGN` and a value corresponding to the receiver name, e.g. `Copenhagen`.

## Set station location

Next, we'll configure the receiver with its geographic location. Unless you know this by heart, you can use [Google Maps](https://maps.google.com) to find it. The corresponding coordinates should appear when you click on your desired location on the map. We are looking for the decimal coordinates, which should look like *60.395429, 5.325127.*

You must also specify the antenna's altitude _in meters_ above sea level. If you need to find the altitude, you use [one of several online services](https://www.maps.ie/coordinates.html). Remember to add the approximate number of corresponding meters if your antenna is above ground level.

1. Set the receiver latitude by creating a [configuration variable](#adding-configuration-variables) for _All services_ with the name `LAT` and a value corresponding to the decimal latitude, e.g. `60.12345`.
2. Set the receiver longitude by creating a [configuration variable](#adding-configuration-variables) for _All services_ with the name `LON` and a value corresponding to the decimal longitude, e.g. `4.12345`.
3. Set the receiver antenna's altitude by creating a [configuration variable](#adding-configuration-variables) for _All services_ with the name `ALT` and a value corresponding to the altitude above sea level in meters, e.g. `45`.

That's it! After the services have restarted, your shiny new OGN station should appear on the map.

# Part 4 – Combining OGN and ADS-B feeding
One of the great things about balena is that it's easy to run several different services on one box with proper isolation. Instructions on how you can combine balena-ogn and balena-ads-b are coming soon. [Subscribe to our newsletter](https://buttondown.email/balena-ads-b/) to be notified when the instructions are ready, or [reach out to the repo's maintainer](https://ketil.mo.land/contact) if you just can't wait – and are ready for some manual work.


# Part 5 – Advanced configuration

## SDR PPM calibration
SDR PPM calibration is only required for non-TCXO SDRs and is currently a manual process in **balena-ogn.** Using a TCXO SDR is highly recommended, as explained in [Part 1 – Build the receiver](#part-1--build-the-receiver). If you need to adjust the PPM, you can do so manually by creating a [configuration variable](#adding-configuration-variables) for the service _ogn_ with the name `OGN_FREQCORR` and a value corresponding to the desired frequency correction, e.g. `40`.

## Feeding to OpenSky Network
In addition to feeding flight data to OGN, you can send the same data to the research project OpenSky Network. The more parties that can use your data, the better, right? 

1. Enable OpenSky Network feeding by creating a [configuration variable](#adding-configuration-variables) for the service _ogn_ with the name `OGN_OPENSKY_ENABLED` and the value `true`.

## Changing WiFi network
If your device comes up without an active connection to the Internet, the `wifi-connect` container will create a network with a captive portal to connect to a local WiFi network. This lets you switch networks after the initial setup without reinstalling the SD card. The SSID for the created hotspot is `balenaWiFi`, and the password is `balenaWiFi`. When connected, visit `http://192.168.42.1:8181/` in your web browser to set up the connection.

## Disabling specific services
You can disable the balena-ogn services by creating a *Device Variable* named `DISABLED_SERVICES` with the services you want to disable as comma-separated values. For example, if you want to disable the ogn service, set the `DISABLED_SERVICES` variable to `ogn`.

# Part 6 – Updating to the latest version
Updating to the latest version is trivial. If you installed balena-ads-b using the blue Deploy with balena-button, you can click it again and overwrite your current application. All settings will be preserved. For convenience, the button is right here:

[![Deploy with button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/ketilmo/balena-ogn&defaultDeviceType=raspberrypi4-64)


If you used the manual `balena push` method, pull the changes from the master branch and push the update to your application with the balena CLI. For complete instructions, look at [Part 2 – Initial setup](#part-2--initial-setup).

Enjoy!

![Visitors](https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fketilmo%2Fbalena-ogn&countColor=%23263759)
