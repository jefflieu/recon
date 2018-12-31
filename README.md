# recon
RECON stands for Reconfigurable which is a collection of different flavours of NIOS-based embedded system. With RECON repository, new user can quickly turn their Altera low-cost FPGA dev board into a more a familiar microcontroller system such as AVR and start making custom logic based off this initial infrastructure.      
Directories structure:
- hw : FPGA hardare/hdl/qsys files
      + cmn : common HDL reused across different architectures
      + recon_xxx : NIOS-based architectures

- sw : Drivers/applications/demo
      + cmn : drivers for peripherals in hw/cmn
      + examples: demonstration applications
      + recon_xxx/bsp: preconfigured bsp for a recon_xxx architecture. For further information, go to the directory and type >make help


