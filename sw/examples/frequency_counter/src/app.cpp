/* Author : Jeff Lieu <lieumychuong@gmail.com>
 * This application counts number of rising edges of one IO pin in 1 second. 
 * By doing so, it demonstrates:  
 *  - ReconIO PWM/Wave-Generator feature
 *  - ReconIO module interrupt and ISR
 *  - ReconTimer interrupt
 *  - Recon Serial object
 * 
 */
#include <system.h>
#include <recon_io.h>
#include <recon_timer.h>
#include <sys/alt_irq.h>
#include <priv/alt_legacy_irq.h>
#include <recon_serial.h>

recon_serial Serial;
u32 freqCntr;
u32 frequency;
u32 timerUp;

#define PWM_PIN 24
/*
 * We put the ISR into the "exception" section 
 */
void io_isr(void* context)  __attribute__ ((section (".exceptions")));
void timer_isr(void* context)  __attribute__ ((section (".exceptions")));

void setup()
{
  /* Put your setup code here */
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Initialize variables
  freqCntr = 0;
  timerUp  = 0;
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Bind Serial Object to UART_0 component by assigning the base address
  Serial.bind(UART_0_BASE);
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Setup serial object with baudrate 115200
  Serial.begin(115200);
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Setup mode of Pins, we have INPUT, OUTPUT and OUTPWM modes
  pinMode(0,OUTPUT);
  pinMode(PWM_PIN,INPUT);
  setPWMPeriod(1000);
  analogWrite(PWM_PIN, 200);
  
  //Note that we always have internal loopback at the pin
  //The pin input path is always available even if we set the pin as OUTPUT or OUTPWM
  //When the pin is set to INPUT mode, it will then turn off the driving buffer
  pinInterrupt(PWM_PIN,RISING_EDGE);
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Setup Timer interrupt interval = 1000 ms (write 1000-1)
  recon_timer_irq_interval(999);
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Enable timer, count down mode and continuous, i.e timer restarts after reaching the interval  
  recon_timer_irq_mode(RECON_TIMER_MODE_COUNT_DOWN|RECON_TIMER_MODE_CONTINUOUS);
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Register Interrupts Service Routines (ISR)
  alt_irq_register(RECON_IO_0_IRQ, &freqCntr, (alt_isr_func) io_isr);
  alt_irq_register(RECON_TIMER_0_IRQ, &freqCntr, (alt_isr_func) timer_isr);
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Print out a message
  Serial.print("Setup done\r\n");
}

void loop()
{
  
  /* Put your code that will be repeatedly call here */
  if (timerUp==1)
    { 
        Serial.print("Frequency is ");
        Serial.println(frequency);
        timerUp = 0;
        digitalWrite(0, TOGGLE);
    }
}

/* 
 * ISR that handles IO IRQ  
 */
void io_isr(void* freqCntr)
{
  ///////////////////////////////////////////////
  //Read back which pin is interrupted
  u32 pin = recon_io_rd32(IRQ_STATUS);
  ///////////////////////////////////////////////
  //Clear Interrupt 
  recon_io_wr32(IRQ_STATUS,pin);
  ///////////////////////////////////////////////
  // On each interrupt, we increment the counter 
  (*((u32*)freqCntr))++;
}

/**
 * ISR that handles Timer Interrupt
 */
void timer_isr(void *context)
{
  //////////////////////////////////////////
  // Clear Interrupt 
  RECON_TIMER_STAT = RECON_TIMER_IRQ_BIT;
  timerUp = 1;
  //////////////////////////////////////////
  // On each interrupt, we latch the current value of frequency counter 
  // and reset the count
  frequency = freqCntr;
  freqCntr  = 0;
}
