#!/bin/sh

###############################################################################
# This file is part of amake
#
# Author: Pavel Milanes (Amateur Radio Operator CO7WT)
#         pavelmc@gmail.com
#         https://github.com/pavelmc/amake
#
# Goal: copy the amake script to /usr/loca/bin/ and give correct permissions
#
###############################################################################


# Detect sudo and try
SUDO=`which sudo`
if [ -n "$SUDO" ] ; then
    echo "Installing amake script, you will be asked for a password, please give it."
    $SUDO cp amake /usr/local/bin
    $SUDO chmod +x /usr/local/bin/amake
    $SUDO chown root.root /usr/local/bin/amake

    echo "Done."
    exit 0
fi


# If no sudo, try su
SU=`which su`
if [ -n "$SU" ] ; then
    echo "Installing amake script, you will be asked for root password, please give it."
    $SU -c "cp amake /usr/local/bin && chmod +x /usr/local/bin/amake && chown root.root /usr/local/bin/amake" root
    
    echo "Done."
    exit 0
fi


# No sudo nor su..... hum...
echo "Can't detect sudo or su executable to do the job."
echo "You need to move the amake file to directory on the PATH variable and"
echo "make it executable."
