#!/bin/bash 
echo "Note: you need to be in nios2_command_shell to run this script"
sof2flash --input=recon_1.sof --output=recon_1.flash --epcs --programmingmode=as
nios2-elf-objcopy -I srec -O ihex recon_1.flash  recon_1.hex
