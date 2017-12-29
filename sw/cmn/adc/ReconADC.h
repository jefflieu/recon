#ifndef __RECON_ADC
#define __RECON_ADC

#include <system.h>
#include "recon_types.h"

#ifdef __ALTERA_MODULAR_ADC

/**
  This class targets Altera's on chip ADC core 
*/
#include "ReconADCHwDescription.h"

#define SEQUENCER_REG(R) HWREG32(m_sequencerBaseAddress + R)
#define SAMPLES_REG(R)  HWREG32(m_storageBaseAddress + SAMPLE_STORAGE_REG+(R<<2))

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
  void setModeRunOnce() {m_modeContinuous = false; SEQUENCER_REG(SEQUENCER_CMD_REG) = SEQUENCER_CMD_MODE_ONCE & SEQUENCER_CMD_MODE_MSK;};
  void setModeRunContinuous() {m_modeContinuous = true; SEQUENCER_REG(SEQUENCER_CMD_REG) = SEQUENCER_CMD_MODE_CONTINUOUS & SEQUENCER_CMD_MODE_MSK;};
  
  /**
    startConversion   : trigger the sequencer start a conversion 
    stopConversion    : wait for the RUN bit to be cleared 
  */
  void startConversion() {SEQUENCER_REG(SEQUENCER_CMD_REG) = SEQUENCER_CMD_RUN_START & SEQUENCER_CMD_RUN_MSK;};
  void stopConversion()  { SEQUENCER_REG(SEQUENCER_CMD_REG) = SEQUENCER_CMD_RUN_STOP & SEQUENCER_CMD_RUN_MSK; 
                           while(SEQUENCER_REG(SEQUENCER_CMD_REG) & SEQUENCER_CMD_RUN_MSK);};
  
  /**
    When FPGA can have dual ADC block, the results are organized into upper and lower 16-bit of the 32-bit register 
    readADC1 returns the lower 16-bit at the slot 
    readADC2 returns the upper 16-bit at the slot 
  */
  u32  readADC1(u32 slot) {return SAMPLES_REG(slot) & 0x00000FFF;};
  u32  readADC2(u32 slot) {return (SAMPLES_REG(slot) & 0x0FFF0000)>>16;};
  
  /**
    Helper to check mode and do pin to channel mapping 
  */
  bool isContinuous() {return m_modeContinuous;};
  void pinRemap(u32 pin, u32 slot) {m_AnaloguePinMap[pin] = slot;};
  
  /**
    Read analogue value from a pin 
  */
  u32  analogRead(u32 pin);  
  
  void enableInterrupt() {HWREG32(m_storageBaseAddress+SAMPLE_STORAGE_IRQ_ENABLE_REG)=SAMPLE_STORAGE_IRQ_ENABLED;}
  void disableInterrupt(){HWREG32(m_storageBaseAddress+SAMPLE_STORAGE_IRQ_ENABLE_REG)=SAMPLE_STORAGE_IRQ_DISABLED;}
  u32  readIrqStatus() {return HWREG32(m_storageBaseAddress+SAMPLE_STORAGE_IRQ_STATUS_REG);}
  void clrIrqStatus(u32 statusMask) {HWREG32(m_storageBaseAddress+SAMPLE_STORAGE_IRQ_STATUS_REG) = statusMask;}
  
  private: 
  bool m_modeContinuous;  
  u32 m_sequencerBaseAddress;
  u32 m_storageBaseAddress;
};

#endif
#endif 
