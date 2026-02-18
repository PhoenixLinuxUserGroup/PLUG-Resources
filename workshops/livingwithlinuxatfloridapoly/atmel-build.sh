#!/usr/bin/sh
## Build script to replace C compilation and upload functionality in Atmel/Microchip Studio
## See the readme (lwlatfpu.md) for added context and usage instructions
## Error out if no filename provided
if [ "$#" -ne 1 ]
then
    echo "[\033[31mERROR\033[m] Usage: $0 <filename>"
    exit 1
fi
## Detect extra flags
while getopts o flag
do
    case "${flag}" in
        o) board=${OPTARG}
    esac
done
## Get on with building
mkdir build
avr-gcc $1 -o build/main -mmcu=atmega328p -O1
echo "[\033[32mNOTE \033[m] Project built!"
## Copy over to .hex file for avrdude
avr-objcopy -j .text -j .data -O ihex build/main build/main.hex
echo "[\033[32mNOTE \033[m] Project copied over!"
## Output to board, ask user where to send it to if not specified
if [ -v $board ]
then
    read -p "Choose where to upload the code to [default: /dev/ttyACM0]:" -r board
    if [ "$board" = "" ] || [ "$board" = "\n" ]
    then
        board="/dev/ttyACM0"
    fi
fi
avrdude -c arduino -p m328p -P /dev/ttyACM0 -U flash:w:build/main.hex
echo "[\033[32mNOTE \033[m] Project successfully uploaded!"
