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
	int pinmode = recon_io_rd32(PINMODE);
	pinmode = (mode==OUTPUT)?
					pinmode|(1<<pin):
						(pinmode&(1<<pin));
	recon_io_wr32(PINMODE, pinmode);
}

void ALT_INLINE digitalWrite(u32 pin, u32 value)
{
	int dataout = recon_io_rd32(DATAOUT);
	dataout = (value==TOGGLE)?
					(dataout^(1<<pin)):
						((value==HIGH)?dataout|(1<<pin):
							(dataout&(~(1<<pin))));
	recon_io_wr32(DATAOUT,dataout);
}

int ALT_INLINE digitalRead(u32 pin)
{
	int datain = recon_io_rd32(DATAIN);
	return ((datain>>pin)&0x1);
}

void  analogWrite(u32 pin, u32 value)
{
	int addr = PWM_VALUE + ((pin&0x3F)<<2);
	recon_io_wr32(addr,value);
}
