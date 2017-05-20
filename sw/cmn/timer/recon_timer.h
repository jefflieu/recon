/*
 * recon_timer.h
 *
 *  Created on: Apr 23, 2017
 *      Author: jeff
 */

#ifndef RECON_TIMER_H_
#define RECON_TIMER_H_
#ifdef __cplusplus
extern "C" {
#endif

#include "system.h"
#include "recon_types.h"

#define RECON_TIMER_MILLISEC_ADDR (RECON_TIMER_0_BASE+0x0)
#define RECON_TIMER_SECOND_ADDR   (RECON_TIMER_0_BASE+0x4)
#define RECON_TIMER_INTERVAL_ADDR (RECON_TIMER_0_BASE+0x8)
#define RECON_TIMER_CTRL_ADDR 	  (RECON_TIMER_0_BASE+0xC)

#define RECON_TIMER_MS *((volatile unsigned long*)RECON_TIMER_MILLISEC_ADDR)
#define RECON_TIMER_S  *((volatile unsigned long*)RECON_TIMER_SECOND_ADDR)
#define RECON_TIMER_I  *((volatile unsigned long*)RECON_TIMER_INTERVAL_ADDR)

#define recon_timer_rd32(n) __builtin_ldwio ((void*)n)
#define recon_timer_wr32(n,v) __builtin_stwio ((void*)n,v)

#define millis() (RECON_TIMER_MS)
#define seconds() (RECON_TIMER_S)

void delay(u32 time);
void delay_second(u32 time);

#ifdef __cplusplus
}
#endif
#endif /* RECON_TIMER_H_ */
