/*
 * recon_types.h
 *
 *  Created on: Apr 27, 2017
 *      Author: jeff
 */

#ifndef RECON_TYPES_H_
#define RECON_TYPES_H_

typedef unsigned long u32;
typedef long s32;
typedef unsigned char u8;
typedef char s8;
typedef unsigned short u16;
typedef short s16;

#define HWREG(R)       (*(volatile u32*)(R))
#define HWREG32(R)     (*(volatile u32*)(R))
#define HWREG16(R)     (*(volatile u16*)(R))
#define HWREG8(R)      (*(volatile u8*)(R))

#endif /* RECON_TYPES_H_ */
