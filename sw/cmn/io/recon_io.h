/*
 * recon_io.h
 *
 *  Created on: Apr 22, 2017
 *      Author: jeff
 */

#ifndef RECON_IO_H_
#define RECON_IO_H_

#include "io.h"
#include "system.h"
#include "recon_types.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define OUTPWM 2
#define OUTPUT 1
#define INPUT  0


#define HIGH   1
#define LOW    0
#define TOGGLE 2

#define RISING_EDGE  1
#define FALLING_EDGE 2

#define RECON_IO_PORT_BASE RECON_IO_0_BASE
#define PINMODE     (RECON_IO_PORT_BASE+0x0)
#define DATAOUT     (RECON_IO_PORT_BASE+0x4)
#define DATAIN      (RECON_IO_PORT_BASE+0x8)
#define PWM_ENA     (RECON_IO_PORT_BASE+0x18)
#define IRQ_STATUS  (RECON_IO_PORT_BASE+0x1C)
#define IRQ_REDGE   (RECON_IO_PORT_BASE+0x24)
#define IRQ_FEDGE   (RECON_IO_PORT_BASE+0x28)
#define PWM_PERIOD  (RECON_IO_PORT_BASE+0x30)
#define PWM_VALUE   (RECON_IO_PORT_BASE+0x40)

#define IRQ_STATUS_REG (*(u32*)IRQ_STATUS)
#define DATAOUT_REG    (*(u32*)DATAOUT)
#define DATAIN_REG     (*(u32*)DATAIN)
#define PINMODE_REG    (*(u32*)PINMODE)
#define PWM_ENA_REG    (*(u32*)PWM_ENA)
#define IRQ_REDGE_REG  (*(u32*)IRQ_REDGE)
#define IRQ_FEDGE_REG  (*(u32*)IRQ_FEDGE)
#define PWM_PERIOD_REG (*(u32*)PWM_PERIOD)

#define recon_io_rd32(n) __builtin_ldwio ((void*)n)
#define recon_io_rd16(n) __builtin_ldhuio ((void*)n)
#define recon_io_rd8(n) __builtin_ldbuio ((void*)n)

#define recon_io_wr32(n,v) __builtin_stwio ((void*)n,v)
#define recon_io_wr16(n,v) __builtin_sthio ((void*)n,v)
#define recon_io_wr8(n,v) __builtin_stbio ((void*)n,v)

void pinMode(u32 pin, u32 mode);
void digitalWrite(u32 pin, u32 value);
u32 digitalRead(u32 pin);
void analogWrite(u32 pin, u32 value);
void pinInterrupt(u32 pin, u32 value);
void setPWMPeriod(u32 value);

#ifdef __cplusplus
}
#endif

#endif /* RECON_IO_H_ */
