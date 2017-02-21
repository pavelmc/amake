Simple interface to build and Arduino project from the command line in linux
============================================================================

Motivation
----------
I love the whole Arduino project idea, but happens that I use Linux OS as may only OS and I hate the lack of modern functions in the provided "Arduino IDE".

Some other users of the Arduino Project faced this (or maybe another) problems and they brought to life the some code projects to make possible to compile his projects without using the default IDE, an example of this is the [Ino](https://github.com/amperka/ino) software; and then when this go deprecated the [Arturo](https://github.com/scottdarch/Arturo/) software take the lead with a folk into modern waters.

I has been using both projects since ever, the idea and software are good, but they has different file structures from the Arduino IDE standard, and this bug me a lot: when you share the code with Arduino IDE Software they (or you) must to tweak the files to make it work.

Then I saw it (a note on the release notes of the Arduino IDE version 1.8.0): now you can build from the command line without the whole IDE apparatus (you don't need a X installed) and this bit me. (Actually it has been on the Arduino IDE since 1.6.x as I can tell, but I don’t know it was **THE TOOL** I was looking for)

Having a way to build the arduino projects with the arduino tools in the command line will help me integrate it to [Geany IDE](http://www.geany.org) my default IDE and keep the WHOLE compatibility of the project; wow!

Taking a peek into the arduino-builder tool I noted that this is still very complicated to configure all the parameters and so, after a few minutes I noted a pattern and started to make a simple bash script to automate this.

This project is my script that I want to share and improve with your help.

Features
--------
* Full arduino integration: same folder structure, same tools, same software.
* Full compatibility with users of the Arduino IDE software.
* You need only to know 3 things:
    * What is your board
    * What programmer you will use to download the code
    * What is the USB port name where the arduino is attached
* This is free software under the GNU GPL version 3.0

Changelog
---------
* Feb/2017: Ease the work with multiple .ino files. You need to make a "amake clean" and then a compilation against the main arduino file, from that point you can compile any .ino file in your editor. (The "amake clean" command reset this behavior, so if you renamed the main arduino file, just make a "clean" and then compile the main file to set it)
* Feb/2017: Make the IDE version configurable and advice the users to do so, as this do impact in code (and firmware) optimizations, and some more little improvements.

Configuration
-------------
You need the Arduino IDE software for Linux in a version equal or greater than 1.6.9 (oldest version that I can test), you can get it on the [official Arduino Site](http[://www.arduino.cc) please download the file (.tar.xz one) and extract it, put the folder where you like, but take note of the place (full path).

If you don't have preferences  just put it right in your home folder.

Once you downloaded and extracted the amake-master.zip from this project, you need to move the amake file to a folder named "bin" in you home folder (you must create it if not there already) once you have the file in place open it for edition with your simple text tool (gedit in Gnome, leafpad in LXDE, kedit in KDE, etc.) then locate a line like this:

```
APATH="~/Documentos/Programación/Arduino/arduino-1.8.1"
```

Then put the path you take note in the previous steps (where you placed the arduino IDE folder) in this line between the "" with no leading or trailing spaces.

Now locate a line like this: (it's a few lines below the previous I mentioned)

```
IDEVER="10801"
```

That makes reference to the actual version number of the Arduino IDE, so, you need to change it to the correct value for the compiling tool-chain to work in optimum shape (I have noticed a size optimization with just the change of this value from one version to the other)

The coding scheme is like this: you will swap every dot in the version number with a zero "0" and that's all; for example in this case we use the 1.8.1 version so the value will be 10801.

If you are using the same version that I state here then nothing needs to be changed.

Next step is to make the amake file executable, you can use your graphic interface tool (right click > properties > make executable) or using the basic command line, like this:

```
chmod +x ~/bin/amake
```

Now you need to configure your IDE build commands, in Geany you can take note of this three:

**Build**

```
cd %d ; amake uno %f
```

Take a peek on the Geany help, the %d is swapped by the actual file path and the %f is swapped with the filename at run time.

'uno' is the board name (you can get details running 'amake list')

**Download**

```
cd %d ; amake uno %f arduino /dev/ttyUSB1
```

In this case the new parameters are the word 'arduino' that is the  programmer type, in this case we are using an Arduino Uno R3 via USB (you can get more details by runing 'amake prog')

The '/dev/ttyUSB1' is the USB port in which the arduino is connected.

**Clean**

Some times you may need to clean you build environment, this common task if set by a command like this:

```
cd %d ; amake clean %f
```

Other IDE tools may need to switch parameters but the ones showed here are very common ones and I know you can adapt it to your preferred IDE tool.

TODO
----

There is  limited board support by now, if you know bash you can hack the code to ad your board (don't forget to notify the working changes to me to include in the code) or simply write and email to me and I will work with you to get your board supported.

Contributing
------------

Code hacks and pull request are always welcomed and appreciated, if you can't code and what to keep this project on going take a peek at the Donations_funding.md file for details.

** 73 de CO7WT, Pavel **
