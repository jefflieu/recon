#!/bin/bash 
sof2flash --input=recon_1.sof --output=recon_1.flash --epcs --programmingmode=as
nios2-flash-programmer recon_1.flash --epcs --base=0x02000000
