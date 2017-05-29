/*
 * recon_serial.cpp
 *
 *  Created on: Apr 27, 2017
 *      Author: jeff
 */

#include "recon_serial.h"
#include <system.h>
#include <sys/alt_stdio.h>
#include <drivers/inc/altera_avalon_uart_regs.h>
#include <stdio.h>
recon_serial::recon_serial(){
}
void recon_serial::bind(u32 base){
  m_baseAddress = base;
}
u32 recon_serial::putstr(const s8* c)
{
  u32 i = 0;
  while(c[i]!='\0'){
    putc(c[i]);
    i++;
  }
  return i;
}

void recon_serial::print(const s8* arg)
{
  putstr(arg);
}

void recon_serial::print(const float f)
{
  char buffer[64];
  /*
   * We need to rely on system sprintf function for floating point implementation
   * If you don't mind the code size, you can use it
   */
  sprintf(buffer,"%f",f);
  putstr(buffer);
}

void recon_serial::print(const u32 d, u32 base)
{
  u32 m = 1000000000;
  u32 a, t;
  u32 lead_zero;
  t = d;
  lead_zero = 1;
  if (base==HEX) {printh(d); return;}
  while(m>0){
    if (t>m) {a = t/m;
          putc(a+48);
          lead_zero = 0;}
    else if (t==m) {putc(49); lead_zero = 0;}
    else putc(lead_zero&&(m>1)?' ':'0');
    t = t%m;
    m = m/10;
  }
}

void recon_serial::print(const s32 d, u32 base)
{
  u32 m = 1000000000;
  u32 t,a;
  u32 lead_zero;
  u32 negative;
  t = d>0?d:-d;
  negative = d>=0?0:1;
  lead_zero = 1;
  if (base==HEX) {printh(d); return;}
  while(m>0){
      if (t>m) {a = t/m;
            if (lead_zero==1&&negative==1) putc('-');
            putc(a+48);
            lead_zero = 0;
            }
      else if (t==m) {if (lead_zero==1&&negative==1) putc('-'); putc(49); lead_zero = 0;
        }
      else putc(lead_zero&&(m>1)?' ':'0');
      t = t%m;
      m = m/10;
    }
}

void recon_serial::printh(u32 d)
{
  s32 m = 28;
  u32 t,a;
  u32 lead_zero;
  t = d;
  lead_zero = 1;
  while(m>=0){
    a = (t >> m) & 0xF;
    if(a!=0){
      if (a<=9) putc(a+'0'); else
        putc((a-10)+'A');
      lead_zero = 0;
    }
    else putc(lead_zero&&m>0?' ':'0');
    m = m - 4;
  }
}

void recon_serial::printb(u32 d)
{
  s32 m = 31;
  u32 t,a;
  u32 lead_zero;
  t = d;
  lead_zero = 1;
  while(m>=0){
    a = (t >> m) & 0x1;
    if(a!=0){
      putc('1');
      lead_zero = 0;
    }
    else putc(lead_zero&&m>0?' ':'0');
    m = m - 1;
  }
}



void inline recon_serial::putc(const s8 c)
{
  while((IORD_ALTERA_AVALON_UART_STATUS(m_baseAddress)&
        ALTERA_AVALON_UART_STATUS_TRDY_MSK)==0);
    IOWR_ALTERA_AVALON_UART_TXDATA(m_baseAddress,c);
}

void recon_serial::println(const s8* s)
{
  print(s);
  putc('\r');
  putc('\n');
}

void recon_serial::println(const u32 d, u32 base)
{
  print(d, base);
  putc('\r');
  putc('\n');
}

void recon_serial::println(const s32 d, u32 base)
{
  print(d, base);
  putc('\r');
  putc('\n');
}

void recon_serial::println(const float f) 
{
  print(f);
  putc('\r');
  putc('\n');
}

void recon_serial::begin(u32 baud)
{
  u16 div = UART_0_FREQ/baud;
  IOWR_ALTERA_AVALON_UART_DIVISOR(m_baseAddress,div);
}

recon_serial::~recon_serial()
{
}
