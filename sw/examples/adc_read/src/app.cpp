#include <system.h>
#include <sys/alt_stdio.h>
#include "recon_timer.h"
#include "ReconADC.h"
#include "recon_serial.h"
#include "kits_parameters.h"

recon_serial Serial;
ReconADC     Adc;

#define analogRead(X) Adc.analogRead(X)

void setup()
{
  /* Put your setup code here */  
  
  ///////////////////////////////////////////////////////////////////////////////////
  // Adc object is defined in the cmn/recon_adc and compiled into the static library
  // To use Adc object, we need to "bind" it to the hardware which is .bind method 
  // Refer to the recon_adc.h for more details of supported method 
  Adc.bind(ADC_0_SEQUENCER_CSR_BASE, ADC_0_SAMPLE_STORE_CSR_BASE);
  
  ///////////////////////////////////////////////////////////////////////////////////
  // pinRemap method maps the pin number to correct analogue channel 
  // For example, for max1000 board, AIN0 = 8. 
  // The definition is created the <BOARD_NAME>.h file 
  // The file is only included when you have correct BOARD_NAME set during make create_app   
  Adc.pinRemap(0, AIN0);
  Adc.setModeRunOnce();
  
  ///////////////////////////////////////////////////////////////////////////////////
  // Bind and initialize the Serial 
  Serial.bind(UART_0_BASE);
  Serial.begin(115200);
}

void loop()
{
  /* Put your code that will be repeatedly call here */
  u32 val;
  delay(100);
  val = analogRead(0);
  Serial.println(val,DEC);
}
