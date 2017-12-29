
#include "ReconADC.h"

#ifdef __ALTERA_MODULAR_ADC


u32 ReconADC::analogRead(u32 pin) {  
  u32 slot;
  if (!m_modeContinuous) {
    startConversion();
    stopConversion();
  }
  slot = m_AnaloguePinMap[pin];
  return readADC1(slot);
}

#endif





