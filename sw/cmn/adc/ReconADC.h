#ifndef __RECON_ADC
#define __RECON_ADC

#include <system.h>
#include "recon_types.h"

#ifdef __ALTERA_MODULAR_ADC

/**
  This class targets Altera's on chip ADC core 
*/
#include <altera_modular_adc.h>

class ReconADC {
    
  public:  
  ReconADC(){};
  ~ReconADC(){};
  
  
  /**
    m_AnaloguePinMap maps the PIN number (index) to the Sequencer's slot number 
  */  
  u32 m_AnaloguePinMap[ADC_0_SAMPLE_STORE_CSR_CSD_LENGTH];
  
  /**
    The ADC object has to be "bound" to a physical hardware by giving 
    @sequencer_base   : base address of the sequencer, you'll find it in the system.h file if your system contains Sequencer block 
    @storage_base     : base address of the conversion results 
  */
  void bind(u32 sequencer_base, u32 storage_base) {m_sequencerBaseAddress = sequencer_base; m_storageBaseAddress  = storage_base;};  
  
  /**
    setModeRunOnce and setModeRunContinuous set the mode of the sequencer: 
    run once          : perform one conversion from slot 0 to slot ADC_0_SAMPLE_STORE_CSR_CSD_LENGTH 
    run continuous    : keep doing conversion in the back ground 
  */
  void setModeRunOnce() {m_modeContinuous = false; ALTERA_MODULAR_ADC_SEQUENCER_MODE_RUN_ONCE(m_sequencerBaseAddress);};
  void setModeRunContinuous() {m_modeContinuous = true; ALTERA_MODULAR_ADC_SEQUENCER_MODE_RUN_CONTINUOUSLY(m_sequencerBaseAddress);};
  
  /**
    startConversion   : trigger the sequencer start a conversion 
    stopConversion    : wait for the RUN bit to be cleared 
  */
  void startConversion() {ALTERA_MODULAR_ADC_SEQUENCER_START(m_sequencerBaseAddress);};
  void stopConversion() {ALTERA_MODULAR_ADC_SEQUENCER_STOP(m_sequencerBaseAddress);};
  
  /**
    When FPGA can have dual ADC block, the results are organized into upper and lower 16-bit of the 32-bit register 
    readADC1 returns the lower 16-bit at the slot 
    readADC2 returns the upper 16-bit at the slot 
  */
  u32  readADC1(u32 slot) {return HWREG32(m_storageBaseAddress + ALTERA_MODULAR_ADC_SAMPLE_STORAGE_REG+(slot<<2)) & 0x00000FFF;};
  u32  readADC2(u32 slot) {return (HWREG32(m_storageBaseAddress + ALTERA_MODULAR_ADC_SAMPLE_STORAGE_REG+(slot<<2)) & 0x0FFF0000)>>16;};
  
  /**
    Helper to check mode and do pin to channel mapping 
  */
  bool isContinuous() {return m_modeContinuous;};
  void pinRemap(u32 pin, u32 slot) {m_AnaloguePinMap[pin] = slot;};
  
  /**
    Read analogue value from a pin 
  */
  u32  analogRead(u32 pin);  
  
  private: 
  bool m_modeContinuous;  
  u32 m_sequencerBaseAddress;
  u32 m_storageBaseAddress;
};

#endif
#endif 
