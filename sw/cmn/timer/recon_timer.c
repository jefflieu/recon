/*
 * recon_timer.c
 *
 *  Created on: Apr 23, 2017
 *      Author: jeff
 */
#include "recon_timer.h"

/* Note:
 * The 32-bit millisecond counter will roll over in about 49 days
 * If your application runs that long or you need to delay more than 25 days,
 * you should use delay second
 */
void delay(u32 time)
{
	u32 expire_time = RECON_TIMER_MS + time;
	while(RECON_TIMER_MS<expire_time){};
}

void delay_second(u32 time)
{
	u32 expire_time = RECON_TIMER_S + time;
	while(RECON_TIMER_S<expire_time){};
}

/*
void delay(u32 time)
{
	u32 expire_time = RECON_TIMER_MS + time;
	u32 current_time;
	do {
	 current_time = RECON_TIMER_MS;
	}
	while(current_time<expire_time||((expire_time^current_time)&0x8000000)!=0){};
}
*/

