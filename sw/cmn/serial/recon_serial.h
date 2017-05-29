/*
 * serial.h
 *
 *  Created on: Apr 27, 2017
 *      Author: jeff
 *  This serial class provides some basic print-out capability that is similar to Arduino platform
 *  You can use the printf instead.
 */

#ifndef SERIAL_H_
#define SERIAL_H_

#include "recon_types.h"
#define DEC 0
#define BIN 1
#define HEX 2

extern "C" {

class recon_serial {
public:
  recon_serial();
  ~recon_serial();

  u32 m_baseAddress;
  void bind(u32 base);
  void begin(u32 baud);
  u32 putstr(const s8* c);
  void putc(const s8 c);
  void print(const s8* s);
  void print(const u32 d, u32 = 0);
  void print(const s32 d, u32 =0 );
  void printh(const u32 d);
  void printb(const u32 d);
  void print(const float f);
  void println(const s8* s);
  void println(const u32 d, u32 = 0);
  void println(const s32 d, u32 =0 );
  void println(const float f);
};

}
#endif /* SERIAL_H_ */
