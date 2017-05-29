/*
 * recon_io.c
 *
 *  Created on: Apr 22, 2017
 *      Author: jeff
 */
#include "recon_types.h"
#include "recon_io.h"
/**
 * set mode of pin
 * @param pin   : pin number 
 * @param mode  : INPUT|OUTPUT|OUTPWM
 * @return none  
 */
void pinMode(u32 pin, u32 mode)
{
  u32 pinmode = recon_io_rd32(PINMODE);
  u32 pwm_ena = recon_io_rd32(PWM_ENA);
  pinmode = (mode==OUTPUT||mode==OUTPWM)?pinmode|(1<<pin):(pinmode&(1<<pin));
  pwm_ena = (mode==OUTPWM)?pwm_ena|(1<<pin):(pwm_ena&(1<<pin));
  recon_io_wr32(PINMODE,pinmode);
  recon_io_wr32(PWM_ENA,pwm_ena);
}

/**
 * Write a digital value to pin 
 * @param pin   : pin number 
 * @param value : HIGH|LOW|TOGGLE
 */
void ALT_INLINE digitalWrite(u32 pin, u32 value)
{
  u32 dataout = recon_io_rd32(DATAOUT);
  dataout = (value==TOGGLE)?
          (dataout^(1<<pin)):
            ((value==HIGH)?dataout|(1<<pin):
              (dataout&(~(1<<pin))));
  recon_io_wr32(DATAOUT,dataout);
}

/**
 * Read pin value 
 * @param pin   : pin number 
 * @return      : 0 - LOW
 *                1 - HIGH 
 */
u32 ALT_INLINE digitalRead(u32 pin)
{
  u32 datain = recon_io_rd32(DATAIN);
  return ((datain>>pin)&0x1);
}

/**
 * set Pulse Width Modulation Value for pin
 * @param pin    :  pin number
 * @param value  :  valid values range on PWM Period settings
 *                  value should always be smaller than or equal to Period Settings
 * @return none
 */
void  analogWrite(u32 pin, u32 value)
{
  u32 addr = PWM_VALUE + ((pin&0x3F)<<2);
  recon_io_wr32(addr,value);
}

/** 
 * Enable Interrupts for pin
 * @param pin    : pin number
 * @param value  : RISING_EDGE or FALLING_EDGE or both
 * @return none
 */
void pinInterrupt(u32 pin, u32 value)
{   u32 tmp;
    tmp = recon_io_rd32(IRQ_REDGE);
    if (value==RISING_EDGE) 
      tmp |= (1<<pin);
    else
      tmp &= (~(1<<pin));
    recon_io_wr32(IRQ_REDGE, tmp);
        
    tmp = recon_io_rd32(IRQ_FEDGE);
    if (value==FALLING_EDGE) 
      tmp |= (1<<pin);
    else
      tmp &= (~(1<<pin));
    recon_io_wr32(IRQ_FEDGE, tmp);
}
/** 
 * Set Period of PWM Counter in number of system clock cycles
 * @param value  : Number of clock cycles to complete 1 PWM cycle.
 *                 Since the counter starts from 0, we need to write (value-1) to the register instead
 * @return none
 */
void setPWMPeriod(u32 value)
{   // Write value - 1 to register 
    HWREG(PWM_PERIOD) = value-1;
}


