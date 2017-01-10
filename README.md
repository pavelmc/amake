Simple interface to build and Arduino project from the command line in linux
============================================================================

Motivation
----------
I love the whole Arduino project idea, but happens that I use Linux OS as may only OS and I hate the lack of modern functions in the IDE.

Some users have my same ideas and they brought to life the [Ino](https://github.com/amperka/ino) software to make this easy and then when this go deprecated the [Arturo](https://github.com/scottdarch/Arturo/) software take the lead with a folk into modern waters.

I has been using both projects since ever, the idea is good, but they has different file structures from the Arduino IDE standard, and this bug me a lot; some functions are not ported and you need to know some other tricks.

Then I saw it, a note on the release notes of the Arduino IDE version 1.8.0: now you can build from the command line without the whole IDE apparatus (you don't need a X installed) and this bit me.

Having a way to build the arduino projects with the arduino tools in the command line will help me integrate it to [Geany IDE](http://www.geany.org) also for arduino and keep the WHOLE compatibility of the project; wow!

Taking a peek into the arduino-builder tool I noted that this is still very complicated to configure all the parameters and so, after a few minutes I noted a pattern and started to make a simple bash script to automate this.

This project is my script that I want to share and improve with your help.


Features
--------
* Full arduino integration: same folder structure, same tools, same software.
* You need only to know 3 things:
    * What is your board
    * What programmer you will use to download the code
    * What is the USB port name where the arduino is attached
* This is free software under the GNU GPL version 3.0


Configuration
-------------
You need the Arduino IDE software for Linux in a version equal or greater than 1.8.0, you can get it con the [official Arduino Site](http[://www.arduino.cc) please download the file and extract it, put the folder where you like, but take note of the place (full path).

If you don't have preferences  just put it right in your home folder.

Then you need to move the amake file to a folder named "bin" in you home folder (you must create it if not there already) once you have the file in place open it for edition with your simple text tool (gedit in Gnome, leafpad in LXDE, kedit in KDE, etc.) then locate a line like this:

```
APATH="~/Documentos/Programación/Arduino/arduino-1.8.0"
```

Then put the path you take note in the previous steps (where you put the arduino IDE folder) in this line between the "" with no leading or trailing spaces.

Now you need to make the amake file executable, you can use your graphic interface tool (right click > properties > make executable) or using the basic command line, like this:

```
chmod +x ~/bin/amake
```

Now you need to configure your IDE build commands, in Geany you can take note of this two:

** Build **

```
cd %d ; amake uno %f
```

Take a peek on the Geany help, the %d is swapped by the actual file path and the %f is swapped with the filename at run time.

'ano' is the board name (you can get details running 'amake list') 

** Download **

```
cd %d ; amake uno %f arduino /dev/ttyUSB1
```

In this case the new parameters are the word 'arduino' that is the  programmer type, in this case we are using an Arduino Uno R3 via USB (you can get more details by runing 'amake prog')

The  '/dev/ttyUSB1' is the USB port in which the arduino is connected.

** Clean **

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
