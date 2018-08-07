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

* This is Linux only tool, developed in Ubuntu 16.04 LTS, and must work with other linux with no problem.
* Full arduino integration: same folder structure, same tools, same software.
* You need only to know 3 things:
    * What is your board
    * What file you need to compile
    * What is the USB port name where the arduino is attached
* Boards and lib support? It will compile all platforms and boards that are installed in your local Arduino Ide environment (using the libs you have installed); for the record you will using the same Arduino IDE tools but with no GUI, nice.
* This is free software under the GNU GPL version 3.0

## Changelog ##

Version 1.2

* August/2018: Adding auto detection of the Arduino IDE installation; it works either if you installed from the repo, downloaded from www.arduino.cc and install it manually or install it using [ubuntu-make](https://wiki.ubuntu.com/ubuntu-make) see the "Configuration" section below. (Thanks to Kjell Morgenstern for the initial feature proposition)
* May/2018: Adding an option to list the auto detected ports for a specific board, and allow to upload to more than one board at a time (Thanks to Don Haig)
* May/2018: The script can now handle devices (boards) with multiple serial identifiers (like clone leonardo boards before being programmed with Arduino) Thanks to Don Haig for pointing the issue and testing the proposed fix.
* May/2018: Switch to full arduino CLI support, now we can compile/upload via CLI EVERY board you have supported in your Arduino IDE environment; thanks to Don Haig for asking support for a non native arduino board, that request push me to give some love to this project again.
* Sep/2017: Bug fix, arduino files with multiple dots in name (like raduino_v1.22.ino) get mangled and the scripts fails, fixed now via a "rev" trick in the shell.
* Feb/2017: Ease the work with multiple .ino files. You need to make a "amake -c" and then a compilation against the main arduino file "amake -v yourfile.ino", from that point you can compile any .ino file in your editor. (The "amake -c" command reset this behavior, so if you renamed the main arduino file, just make a "clean" and then compile the main file to set it)
* Feb/2017: Make the IDE version configurable and advice the users to do so, as this do impact in code (and firmware) optimizations, and some more little improvements
* Feb/2017: Auto detection of the serial port; for now just USB-Serial adapters based on the CH340/341 chips.

## Configuration ##

You need the Arduino IDE software for Linux in a version equal or greater than 1.6.9 (oldest version that I can test), you can get it on the [official Arduino Site](http://www.arduino.cc); the installation is out of the scope of this document, but Google is your friend: ["How to install the Arduino IDE in linux"](https://www.arduino.cc/en/Guide/Linux)

As the official doc says, put it or install it on any folder, but always under your $HOME directory.

Alternatively it you use Ubuntu you can give the [ubuntu-make](https://wiki.ubuntu.com/ubuntu-make) software a try.

**WARNING:** From August/2018 the software makes an auto-detection of the Arduino IDE installed, this auto-detection can fail if you have more than one instance (version) of the Arduino IDE; please remove the install directory for older versions to get rid of this issues. You has been warned.

Then download and extract the code from this project **(GREEN button at top-right "Clone or download")**, now you need to install the software. For that you need to fire a terminal/console/shell and move to the folder you extracted the amake documents; then run the install script, like this:

```
pavel@laptop:~$ chmod +x install.sh
pavel@laptop:~$ ./install.sh
Installing amake script, you will be asked for a password, please give it.
[sudo] Password for user pavel:
Done.
pavel@laptop:~$
```

Now is time to run & test it, run this in any bash console:

```
amake
```

**Warning**: The first time you run the script it may run slow as it's working on the auto detection behind scenes.

If all goes well you will get the "usage" text, read it, then try this to know what boards are supported by aliases:

```
amake -b
```

Now you need to configure your IDE build commands, in Geany you can take note of this three:

**Verify or compile it**

```
cd %d ; amake -v uno %f
```

Take a peek on the Geany help, the %d is swapped by the actual file path and the %f is swapped with the filename at run time.

The "-v" switch tells the script that you want to verify (aka compile) your sketch to detect errors.

'uno' is the board alias name (you can get details running 'amake list')

Once you successfully compiled it once, amake will take the board and file (the 'uno' and '%f' parameter) as optionals (that info is stored in a local hidden file on your project folder named .amake)

This trick will be very useful when you try to compile a multi file project as you can compile against any file in the project, **always after compiling it successfully against the main file** be aware that 'amake -c' will reset this. This feature is important for people that manages all the code in the command line, once you compile it once successfully you can simply do this:

```
amake -v
```

**Upload to a board**

```
cd %d ; amake -u uno %f /dev/ttyUSB1
```

The "-u" switch tells the script that you want to upload your hex code to the board (it will verify it first if needed)

'uno' is the board alias name (you can get details running 'amake list')

The '/dev/ttyUSB1' is the USB port in which the arduino is connected.

The serial port parameter can be omitted if you use a Chinese arduino or a cheap USB-Serial adapter, amake will autodetect it. If amake can't detect the port and you don't pass it on the command line it will default to /dev/ttyUSB0.

The serial port auto detection also works on some newer boards with an auto detecting USB port routine on uploading, like some samd boards (Adafruit Trinket M0, Arduino Trinket M0, Leonardo and counting up)

The "-u" switch also uses the trick of caching the board and file details described on the "-v" switch, add to this the auto detection of the usb port and you can do just this on the command line:

```
amake -u
```

Remember: always after being successfully compiled it once and be aware that 'amake -c' will reset this.

**Clean the environment**

Some times you may need to clean you build environment, this common task if set by a command like this:

```
cd %d ; amake -c %f
```

The "-c" parameter also unset the feature of caching the board and file; after a "clean" you must always compile the project against the main file to gain that feature again.

Even so, if you had successfully compiled it on the past then you can dismiss the "%f" parameter (just once, as a '-c' switch will break that feature)

## Other IDEs ##

Other IDE tools (vi, atom, eclipse) may need to switch parameters but the ones showed here are very simple as an example and I know you can adapt it to your preferred IDE tool.

## How it works? ##

This script just invoke the command line interface for the Arduino IDE and do some simplifications, checks and default tricks to make your live easier.

Basically it can compile and upload ANY board you can compile and upload with the Arduino IDE graphical user interface, even the newlly installed via the Board Manager, or the ones you put in your local hardware directory: if the Arduino IDE see it and work with then you can use it from the command line.

The compiler is set with a persistent build path to speed up the compilation upon smaller changes, be aware that in some cases you will need to make an "amake -c" to reset (ERASE) the temporal build path and compile the sketch from zero.

I make some sacrifices in the process of make this easy from the command line, this is a list of them:

### Board Aliases and real names ###

The Arduino IDE uses a schema for the user friendly names and **full qualified board names** (fqbn), I have not built automatic support for it, yet, so I introduces what is know as board aliases.

The Arduino IDE uses the fqbn of the board and that can be a tricky game, some examples:

* "arduino:avr:uno" just for a Arduino/Genuino uno board
* "adafruit:samd:adafruit_trinket_m0" for the Adafruit Trinket M0 board
* "MegaCore:avr:128:BOD=2v7,LTO=Os,clock=16MHz_external" for a MegaCore ATMega128 board with a 16MHz externaly generated clock.

You see the point? that's why I have embedded some aliases and I can update it along the way to make your life easier.

Even so if there is no alias for a supported board, you can compile a sketch against it, just activate the option in the Arduino IDE for showing debug output on compiling and take a peek on the debug output, look for a -fqbn parameter in the first lines (scroll to the right)

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

Once you have managed to upload it successfully using the default USB or a custom programmer (LPT port, USB to Serial TTL adapter or even a Pickit2) it will work on the command line for amake, just as it does in the Arduino IDE.

At least all the classic arduinos work with this method, no matter if with native USB or a USB to TTL adapter, or using a Pickit2 as a ICP programmer.

That's because amake will use the cached programming method you used with the Arduino IDE.

**Warning**

I have not any modern board based on samd or stm32 patform, all this ones has a different schemas for the upload, in theory it must work once you make it work in the IDE, if not please rise an issue in the project page at github and I will work it out with your help.

## Contributing ##

Code hacks, ideas, tips and pull requests are always welcomed and appreciated; also if you can't code there are a few things you can do to contribute:

* Spot a grammar or syntax error on the docs/code and let me know; English is my second one and I'm not proficient yet.
* You have a board not supported and some spare time (a few minutes)? drop me and email and I will schedule a time to be on-line with you to test some things or simply advice on you to make some test and pass me the results and I will do the rest: the board will be supported ASAP.
* Arduino or arduino compatible boards are not easy to get items here also, you can donate some of your - not used boards - and I can put them to work here, also compatible devices and shields are welcomed.
* Donate Internet or Cell air time to me, I live in the Cuba island and the Internet/Cell service is very expensive here; by this way you can help me stay connected.
* Simply donate the cost of a beer/coffee if you like to do so, of course more than one is allowed ;-)

**Remember:** No payment of whatsoever is required to use this code: this is [Free/Libre Software](https://en.wikipedia.org/wiki/Software_Libre), nevertheless donations are very welcomed.

If you like to contribute in any way please contact the author at pavelmc@gmail.com for instructions on how to do it.

Thanks in advance and enjoy the ride.

**73 de CO7WT, Pavel**
