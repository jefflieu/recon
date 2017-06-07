/*
  Project: RECON 2017
  Author: Jeff Lieu <lieumychuong@gmail.com>
  Description: IO port that supports up to 32 pins 
                + Support PWM with programmable PWM Period
                + Support Interrupts on Changes of Input 

*/

/////////////////////////////////////////////////////////////////////////////////
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

/* Address definition */
`define     DIR_OFFSET    0
`define     OUT_OFFSET    1
`define      IN_OFFSET    2
`define OUT_SET_OFFSET    3
`define OUT_CLR_OFFSET    4
`define OPENDRN_OFFSET    5 
`define PWM_ENA_OFFSET    6
`define IRQ_STATUS_OFFSET 7
`define IRQ_ENA_OFFSET    8
`define IRQ_REDGE_OFFSET  9
`define IRQ_FEDGE_OFFSET 10
`define DBNC_ENA_OFFSET  11
`define PWM_PERIOD_OFFSET   12
`define PWM_VALUE_OFFSET    16


module recon_io (
                       // Avalon Interface
                       // This is a simplest way of communicating to the Processor
                       // Signals names are self descriptive 
                       address,     
                       chipselect,
                       clk,
                       reset_n,
                       write,
                       read,
                       writedata,
                       readdata,
                       
                       // Interrupt sender port 
                       // Interrupt is held high until it's cleared by software ISR that serves the interrupt
                       irq,
                       
                       // IO Port
                       io_out   ,
                       io_in    ,
                       io_oe    ,
                       io_opdrn
                       
                    )
;
  parameter        PORT_WIDTH = 16;
  parameter        PWM_CNTR_WIDTH  = 8;  
  output  [ 31: 0] readdata;
  input   [  5: 0] address;
  input            chipselect;
  input            clk;
  input            reset_n;
  input            write;
  input            read;
  input   [ 31: 0] writedata;
  output  [PORT_WIDTH-1:0] io_out;
  output  [PORT_WIDTH-1:0] io_oe;
  output  [PORT_WIDTH-1:0] io_opdrn;
  input   [PORT_WIDTH-1:0] io_in;
  output  irq;
  
  wire    [ 31: 0] readdata;
  wire             clk_en;
  reg     [ PORT_WIDTH-1: 0] data_out;
  wire    [ PORT_WIDTH-1: 0] out_port;
  reg     [ PORT_WIDTH-1: 0] read_mux_reg;
  
  reg     [ PORT_WIDTH-1: 0] pin_mode;
  reg     [ PORT_WIDTH-1: 0] pin_opdrn;
  reg     [ PORT_WIDTH-1: 0] data_in;
  reg     [ PORT_WIDTH-1: 0] data_in_r1;
  reg     [ PORT_WIDTH-1: 0] data_in_r2;
  reg     [ PORT_WIDTH-1: 0] data_in_event;  
  reg     [ PORT_WIDTH-1: 0] pwm_ena;
  reg     [ PORT_WIDTH-1: 0] pwm_out;
  wire    [ PORT_WIDTH-1: 0] irq_ena;
  reg     [ PORT_WIDTH-1: 0] irq_redge;
  reg     [ PORT_WIDTH-1: 0] irq_fedge;
  reg     [ PORT_WIDTH-1: 0] irq_status;
  reg     [ PWM_CNTR_WIDTH  : 0] pwm_values[PORT_WIDTH-1:0];
  reg     [ PWM_CNTR_WIDTH-1: 0] pwm_cntr;
  reg     [ PWM_CNTR_WIDTH  : 0] pwm_period;
  
  
  assign clk_en = 1;
 
  initial 
    begin 
      pwm_ena <= 0;
    end 
  
  /**
  A very basic and important component in HDL is a register which is described by always(@posedge clk) statement 
  This statement says that: 
    - At positive edge of clock 
      - If chipselect and read are asserted 
        - Latch the read_mux_reg with the following values depending on the address 
    - The case statement describes a multiplexer, in this case 13:1 multiplexer
    - When the case statement is included in a "clocked" statement, the output of the multiplexer goes into a Register to store the value
  */
  always@(posedge clk)
  begin 
    if (chipselect && read)
      case(address)
      `DIR_OFFSET       : read_mux_reg <= pin_mode;
      `OUT_OFFSET       : read_mux_reg <= data_out;
      `IN_OFFSET        : read_mux_reg <= data_in;
      `OUT_SET_OFFSET   : read_mux_reg <= 32'h0;
      `OUT_CLR_OFFSET   : read_mux_reg <= 32'h0;
      `OPENDRN_OFFSET   : read_mux_reg <= pin_opdrn;
      `IRQ_ENA_OFFSET   : read_mux_reg <= irq_ena;
      `PWM_ENA_OFFSET   : read_mux_reg <= pwm_ena;
      `IRQ_STATUS_OFFSET: read_mux_reg <= irq_status;
      `IRQ_REDGE_OFFSET : read_mux_reg <= irq_redge;
      `IRQ_FEDGE_OFFSET : read_mux_reg <= irq_fedge;
      `PWM_PERIOD_OFFSET: read_mux_reg <= pwm_period;
      default           : read_mux_reg <= data_in;
      endcase 
    end 
  assign readdata = {32'b0 | read_mux_reg};
  
  /* Settings registers 
    This statement describes registers with asynchronous reset 
    we have 5 registers:
      pin_mode, pwm_ena, irq_redge, irq_fedge and pwm_period
    These are asynchronuously reset by the reset_n signal 
    And synchronously captured the value on the writedata bus when :
      - chipselect is assered
      - write signal is asserted 
      - and the address matches the register's address 
  */
  integer I;  
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0) begin 
          pin_mode <= 0;
          pwm_ena  <= 0;
          irq_redge<= 0;
          irq_fedge<= 0;   
          pwm_period[PWM_CNTR_WIDTH] <= 1'b1;
          pwm_period[PWM_CNTR_WIDTH-1:0] <= 0;     
        end 
      else begin 
        if (chipselect && write && (address == `DIR_OFFSET)) begin 
          pin_mode  <= writedata;
        end 
        if (chipselect && write && (address == `PWM_ENA_OFFSET)) begin 
          pwm_ena   <= writedata;
        end
        if (chipselect && write && (address == `IRQ_REDGE_OFFSET)) begin 
          irq_redge <= writedata;
        end
        if (chipselect && write && (address == `IRQ_FEDGE_OFFSET)) begin 
          irq_fedge <= writedata;
        end
        if (chipselect && write && (address == `PWM_PERIOD_OFFSET)) begin 
          pwm_period <= writedata;
        end
      end       
    end
  /* This is a combinatorial statement 
    when you use "assign" to describe the behavior, it is synthesized into Combinatorial logic, i.e there's no registers to hold value 
    in this case 
    irq_ena is the output of an or gate whose inputs are irq_redge and irq_fedge. 
    This simply says that when either irq_redge or irq_fedge is set, we enable the interrupt
  */
  assign irq_ena = irq_redge | irq_fedge;
  
  /* 
  Data Out Register 
  */
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;          
      else 
        for(I=0;I<PORT_WIDTH;I=I+1) 
        begin 
          if (chipselect && write && (address == `OUT_OFFSET))
              data_out[I] <= writedata[I];
          else if (chipselect && write && (address == `OUT_SET_OFFSET))
            begin 
              if (writedata[I]==1'b1) data_out[I] <= 1'b1;        
            end 
          else if (chipselect && write && (address == `OUT_CLR_OFFSET))
            begin 
              if (writedata[I]==1'b1) data_out[I] <= 1'b0;
            end 
        end    
    end
  
  /* 
    Data In is read directly 
  */  
  always@(posedge clk)
    begin 
      data_in <= io_in;
      data_in_r1 <= data_in;
      data_in_r2 <= data_in_r1;
      
      /* Detect rising edge and falling edge if it's enabled 
         It is very common in HDL to capture Rising edge or falling edge of a signal using 2 stages of registers 
         When the signal changes level, the 2 stages of register will have different values
         By feeding 2 stages of registers into LOGIC gates, we can detect the rising_edge or falling edge events 
      */
      data_in_event <= (irq_redge & (data_in_r1 & ~data_in_r2))|
                       (irq_fedge & (~data_in_r1 & data_in_r2));
      
      /* 
         Latch the event, if the IRQ is enabled for this pin 
         or clear when we write 1 to the status
         IRQ_STATUS is a vector of bits. Each bit holds in interrupt event for each pin 
         This loop will be unrolled into multiple of if else statements, each IF/ELSE statement describes behavior of 1 bit
      */
      for(I=0;I<PORT_WIDTH;I=I+1)
        if(data_in_event[I]==1'b1 && irq_ena[I]==1'b1)
          irq_status[I] <= 1'b1;
        else if (chipselect && write && address == `IRQ_STATUS_OFFSET && writedata[I]==1'b1)
          irq_status[I] <= 1'b0;
    end 
  
  /* 
    | <bit vector> perform OR operations of all the bits in the vector 
  */
  assign irq = | irq_status;
  
  /* 
  PWM values registers 
  Again, FOR loop in HDL will be unrolled, usually the RANGE of For loop is a constant 
  */
  always@(posedge clk)
    begin 
      for(I=0;I<PORT_WIDTH;I=I+1)
        if (chipselect && write && address==(I+16))
          begin 
            pwm_values[I] <= writedata;
          end 
    end 
  
  /* 
     Generating PWM Pulses 
     Only 1 counter is running, the rest are just comparators
     PWM Rising edges of all pins are aligned
  */
  always@(posedge clk)
    begin 
      /** 
      * Counter runs from 0 to pwm_period and reset 
      * Note that <= is "unblocked" statement, so the below statement would be effective if the contition is true
      */
      pwm_cntr <= pwm_cntr + 1;
      if (pwm_cntr == pwm_period) pwm_cntr <= 0;
      
      /**
      * Comparators to generate PWM values. 
      * This loop is actually unrolled into a bunch of comparators running in parallel 
      */
      for(I=0;I<PORT_WIDTH;I=I+1)
        if (pwm_cntr<pwm_values[I]) 
          pwm_out[I] <= pwm_ena[I]; 
        else
          pwm_out[I] <= 1'b0;
    end 
  
  genvar IO;
  generate 
  for(IO=0;IO<PORT_WIDTH;IO=IO+1) 
  begin: assignpins
    assign io_oe[IO]   = pin_mode[IO]|pwm_ena[IO];
    assign io_out[IO]  = pwm_ena[IO]?pwm_out[IO]:data_out[IO];
    assign io_opdrn[IO]= pin_opdrn[IO];
  end 
  endgenerate 
  

endmodule


