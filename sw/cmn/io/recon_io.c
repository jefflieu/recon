/*
 * recon_io.c
 *
 *  Created on: Apr 22, 2017
 *      Author: jeff
 */
#include "recon_types.h"
#include "recon_io.h"

void pinMode(u32 pin, u32 mode)
{
  u32 pinmode = recon_io_rd32(PINMODE);
  u32 pwm_ena = recon_io_rd32(PWM_ENA);
  pinmode = (mode==OUTPUT||mode==OUTPWM)?pinmode|(1<<pin):(pinmode&(1<<pin));
  pwm_ena = (mode==OUTPWM)?pwm_ena|(1<<pin):(pwm_ena&(1<<pin));
  recon_io_wr32(PINMODE,pinmode);
  recon_io_wr32(PWM_ENA,pwm_ena);
}

void ALT_INLINE digitalWrite(u32 pin, u32 value)
{
  u32 dataout = recon_io_rd32(DATAOUT);
  dataout = (value==TOGGLE)?
          (dataout^(1<<pin)):
            ((value==HIGH)?dataout|(1<<pin):
              (dataout&(~(1<<pin))));
  recon_io_wr32(DATAOUT,dataout);
}

u32 ALT_INLINE digitalRead(u32 pin)
{
  u32 datain = recon_io_rd32(DATAIN);
  return ((datain>>pin)&0x1);
}

void  analogWrite(u32 pin, u32 value)
{
  u32 addr = PWM_VALUE + ((pin&0x3F)<<2);
  recon_io_wr32(addr,value);
}
