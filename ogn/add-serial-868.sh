#!/usr/bin/env bash

RTLSDR_SERIAL=00000868

echo The following script will add a serial number to your RTLSDR USB dongle. 
echo The serial number is: $RTLSDR_SERIAL
echo To confirm that you want to proceed, type YES below.
read CONFIRMATION

if ! [[ "$CONFIRMATION" = "YES" ]]; then
        echo "Not confirmed, exiting."
        exit
fi
echo " "
echo Please ensure that you only have one single RTLSDR USB dongle connected to your computer.
echo To confirm that you only have one RTLSDR USB dongle connected, type ONE below.

read CONFIRMATIONNUMBER

if ! [[ "$CONFIRMATIONNUMBER" = "ONE" ]]; then
        echo "Not confirmed, exiting."
        exit
fi
echo " "

rtl_eeprom -s $RTLSDR_SERIAL