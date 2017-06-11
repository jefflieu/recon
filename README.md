# recon
RECON stands for Reconfigurable
Directories structure:
- hw : FPGA hardare/hdl/qsys files
      + cmn : common HDL reused across different architecres
      + recon_xxx : NIOS-based architectures

- sw : Drivers/applications/demo
      + cmn : drivers for peripherals in hw/cmn
      + examples: demonstration applications
      + recon_xxx/bsp: preconfigured bsp for a recon_xxx architecture. For further information, go to the directory and type >make help


