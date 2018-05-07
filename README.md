# Simple interface to build and Arduino project from the command line in linux #

## Motivation ##

I love the whole Arduino project idea, but happens that I use Linux OS as may only OS and I hate the lack of modern functions in the provided "Arduino IDE".

Some other users of the Arduino Project faced this (or maybe another) problems and they brought to life the some code projects to make possible to compile his projects without using the default IDE, an example of this is the [Ino](https://github.com/amperka/ino) software; and then when this go deprecated the [Arturo](https://github.com/scottdarch/Arturo/) software take the lead with a folk into modern waters.

I has been using both projects since ever, the idea and software are good, but they has different file structures from the Arduino IDE standard, and this bug me a lot: when you share the code with other people that use only the Arduino IDE Software they (99 percernt of the time will be you) must to tweak the files to make it work.

Then I saw it (a note on the release notes of the Arduino IDE version 1.8.0): now you can build from the command line without the whole IDE apparatus (you don't need a X installed) and this bit me. (Actually it has been on the Arduino IDE since 1.5.x as I can tell, but I don’t know it was **THE TOOL** I was looking for)

Having a way to build the arduino projects with the arduino tools in the command line will help me integrate it to [Geany IDE](http://www.geany.org) my default IDE and keep the WHOLE compatibility of the project; Wow!

First approach was using directly the arduino-builder tool, that approach worked well with defaults arduino boards, but once you get on other plattforms and compilers... things start to be difficult, so to avoid that I switched completely to use the arduino CLI.

This script is a way to make the Arduino IDE CLI even simpler, I will support it as long as it's is usefull for me and others, so please let me know it's a nice tool for you.

## Features ##

* This is Linux only tool, developed in Ubuntu 16.04 TLS, and must work with other linux with no problem.
* Full arduino integration: same folder structure, same tools, same software.
* You need only to know 3 things:
    * What is your board
    * What file you need to compile
    * What is the USB port name where the arduino is attached
* Boards and lib support? It will compile all platforms and boards that are installed in your local Arduino Ide environment (using the libs you have installed); for the record you will using the same Arduino IDE tools but with no GUI, nice.
* This is free software under the GNU GPL version 3.0

## Changelog ##

Version 1.0 (**Warning** from this version and forward I changed the command line parameters.)

* May/2018: Switch to full arduino CLI support, now we can compile/upload via CLI EVERY board you have supported in your Arduino IDE environment; thanks to Don Haig for asking support for a non native arduino board, that request push me to give some love to this project again.
* Sep/2017: Bug fix, arduino files with multiple dots in name (like raduino_v1.22.ino) get mangled and the scripts fails, fixed now via a "rev" trick in the shell.
* Feb/2017: Ease the work with multiple .ino files. You need to make a "amake clean" and then a compilation against the main arduino file, from that point you can compile any .ino file in your editor. (The "amake clean" command reset this behavior, so if you renamed the main arduino file, just make a "clean" and then compile the main file to set it)
* Feb/2017: Make the IDE version configurable and advice the users to do so, as this do impact in code (and firmware) optimizations, and some more little improvements
* Feb/2017: Auto detection of the serial port; for now just USB-Serial adapters based on the CH340/341 chips.

## Configuration ##

You need the Arduino IDE software for Linux in a version equal or greater than 1.6.9 (oldest version that I can test), you can get it on the [official Arduino Site](http[://www.arduino.cc) please download the file (.tar.xz one) and extract it, put the folder where you like, but take note of the place (full path).

If you don't have preferences  just put it right in your home folder. I like to have it elsewhere and make a link to that folder named in "~/Documents/Software/Arduino/latest-ide", but please note (write it down) the full path.

Once you downloaded and extracted the amake-master.zip from this project, you need to move the amake file to a folder named "bin" in you home folder (you must create it if not there already) once you have the file in place open it for edition with your simple text tool (gedit in Gnome, leafpad in LXDE, kedit in KDE, etc.) then locate a line like this:

```
APATH="~/Documents/Software/Arduino/latest-ide"
```

Then put the path you take note in the previous steps (where you placed the arduino IDE folder) in this line between the "" with no leading or trailing spaces.

Next step is to make the amake file executable, you can use your graphic interface tool (right click > properties > make executable) or using the basic command line, like this:

```
chmod +x ~/bin/amake
```

Now is time to run & test it, run this in any bash console:

```
amake
```

If all goes well you will get the "usage" text, read it, then try this to know what boards are supported by aliases:

```
amake list
```

Now you need to configure your IDE build commands, in Geany you can take note of this three:

**Verify or compile it**

```
cd %d ; amake -v uno %f
```

Take a peek on the Geany help, the %d is swapped by the actual file path and the %f is swapped with the filename at run time.

The "-v" switch tells the script that you want to verify (aka compile) your sketch to detect errors.

'uno' is the board alias name (you can get details running 'amake list')

Once you successfully compiled it once, amake will ignore the %f parameter; this trick will be very useful when you try to compile a multi file project as you can compile against any file in the project, **always after compiling it first again the main file** ('amake clean' will reset this)

**Upload to a board**

```
cd %d ; amake -u uno %f /dev/ttyUSB1
```

The "-u" switch tells the script that you want to upload your hex code to the board (it will verify it first if needed)

'uno' is the board alias name (you can get details running 'amake list')

The '/dev/ttyUSB1' is the USB port in which the arduino is connected.

The port part can be omitted if you use a Chinese arduino or a cheap USB-Serial adapter as amake will autodetect it. If amake can't detect the port and you don't pass it on the command line it will default to /dev/ttyUSB0

**Clean the environment**

Some times you may need to clean you build environment, this common task if set by a command like this:

```
cd %d ; amake -c %f
```

The "clean" parameter also unset the property of amake in which you can compile a project against any .ino file in the project folder; after a "clean" you must always compile the project against the main file to gain that feature again.

Other IDE tools may need to switch parameters but the ones showed here are very common ones and I know you can adapt it to your preferred IDE tool.

## How it works? ##

This script just invoke the command line interface for the Arduino IDE and do some simplifications, checks and default tricks to make your live easier.

Basically it can compile and upload ANY board you can compile and upload with the Arduino IDE graphical user interface, even the newlly installed via the Board Manager, or the ones you put in your local hardware directory: if the Arduino IDE see it and work with then you can use it from the command line.

But, always is a but... I make some sacrifices in the process, this is a list of them:

### Board Aliases and real names ###

The Arduino IDE uses a schema for the user fliendly names and full qualified board names (fqbn), I have not deciphered it yet, so I introduces what is know as board aliases.

The Arduino IDE uses the fqbn of the board and that can be a tricky game, some examples:

* "arduino:avr:uno" just for a Arduino/Genuino uno board
* "adafruit:samd:adafruit_trinket_m0" for the Adafruit Trinket M0 board
* "MegaCore:avr:128:BOD=2v7,LTO=Os,clock=16MHz_external" for a MegaCore ATMega128 board with a 16MHz externaly generated clock.

You see the point? that's why I have embedded some aliases and I can update it along the way to make your life easier.

Even so if there is no alias for a supported board you can use it, just activate the option in the Arduino IDE for showing debug output on compiling and take a peek on the debug output, look for a -fqbn parameter in the fisrt lines (scroll to the right)

For example, you can see an output like this for a Arduino Star Otto (STM23F4) board:

```
/home/pavel/Documentos/Software/Arduino/arduino-1.8.5/arduino-builder -dump-prefs -logger=machine -hardware /home/pavel/Documentos/Software/Arduino/arduino-1.8.5/hardware -hardware /home/pavel/.arduino15/packages -hardware /home/pavel/Arduino/hardware -tools /home/pavel/Documentos/Software/Arduino/arduino-1.8.5/tools-builder -tools /home/pavel/Documentos/Software/Arduino/arduino-1.8.5/hardware/tools/avr -tools /home/pavel/.arduino15/packages -built-in-libraries /home/pavel/Documentos/Software/Arduino/arduino-1.8.5/libraries -libraries /home/pavel/Arduino/libraries -fqbn=arduino:stm32f4:star_otto -ide-version=10805 -build-path /tmp/arduino_build_549136 -warnings=none -build-cache /tmp/arduino_cache_19855 -prefs=build.warn_data_percentage=75 -prefs=runtime.tools.arm-none-eabi-gcc.path=/home/pavel/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/4.8.3-2014q1 -prefs=runtime.tools.dfu-util.path=/home/pavel/.arduino15/packages/arduino/tools/dfu-util/0.9.0-arduino1 -prefs=runtime.tools.arduinoSTM32load.path=/home/pavel/.arduino15/packages/arduino/tools/arduinoSTM32load/2.0.0 -verbose /home/pavel/Arduino/Blink/Blink.ino
```

If you look carefully you can detect the string "-fqbn=arduino:stm32f4:star_otto" so you can invoke amake just like this for verify/compile an sketch in this particular board:

```
cd %d ; amake -v arduino:stm32f4:star_otto %f
```

Why I don't parse all the platform/board data and put it as aliases already? New boards came into the wild every day, it's a endeless task and this is a hobby for me.

### Programmers ###

So, you have managed to verify (compile) your sketch and it's working, how I can automate the upload process in the command line?

Fire your Arduino IDE instance, configure the blink.ino example code for your particular board (no matter what board, if OEM or third party) and do an upload.

Once you have managed to upload it with the default USB or a custom programmer (LPT port, USB to Serial TTL adapter or even a Pickit2) it will work on the command line for amake, just as it does in the Arduino IDE.

At least all the classic arduinos work wih this method, no matter if with native USB or a USB to TTL adapter, or using a Pickit2 as a ICP programmer.

**Warning**

I have not any modern board based on samd or stm32 patform, all this ones has a different schemas for the upload, in theory it must work once you make it work in the IDE, if not please rise an issue in the project page at github and I will work it out with your help.

## Contributing ##

Code hacks and pull request are always welcomed and appreciated, if you can't code and what to keep this project on going take a peek at the Donations_funding.md file for details.

** 73 de CO7WT, Pavel **
