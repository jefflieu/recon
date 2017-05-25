/*
  Project: RECON 2017
  Author: Jeff Lieu <lieumychuong@gmail.com>
  Description: IO port that supports up to 32 pins 
                + Support PWM
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
`define PWM_VALUE_OFFSET 16


module recon_io (
                       // Avalon Interface
                       address,
                       chipselect,
                       clk,
                       reset_n,
                       write,
                       read,
                       writedata,
                       readdata,
                       
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
  reg     [ PORT_WIDTH-1: 0] irq_ena;
  reg     [ PORT_WIDTH-1: 0] irq_redge;
  reg     [ PORT_WIDTH-1: 0] irq_fedge;
  reg     [ PORT_WIDTH-1: 0] irq_status;
  reg     [ PWM_CNTR_WIDTH  : 0] pwm_values[PORT_WIDTH-1:0];
  reg     [ PWM_CNTR_WIDTH-1: 0] pwm_cntr;
  
  
  assign clk_en = 1;
 
  initial 
    begin 
      pwm_ena <= 0;
    end 
  
  
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
      `PWM_ENA_OFFSET   : read_mux_reg <= pwm_ena;
      `IRQ_STATUS_OFFSET: read_mux_reg <= irq_status;
      `IRQ_ENA_OFFSET   : read_mux_reg <= irq_ena;
      `IRQ_REDGE_OFFSET : read_mux_reg <= irq_redge;
      `IRQ_FEDGE_OFFSET : read_mux_reg <= irq_fedge;
      default           : read_mux_reg <= data_in;
      endcase 
    end 
  assign readdata = {32'b0 | read_mux_reg};
  
  /* Settings registers */
  integer I;  
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0) begin 
          pin_mode <= 0;
          pwm_ena  <= 0;
          irq_ena  <= 0;
          irq_redge<= 0;
          irq_fedge<= 0;        
        end 
      else begin 
        if (chipselect && write && (address == `DIR_OFFSET)) begin 
          pin_mode  <= writedata;
        end 
        if (chipselect && write && (address == `PWM_ENA_OFFSET)) begin 
          pwm_ena   <= writedata;
        end
        if (chipselect && write && (address == `IRQ_ENA_OFFSET)) begin 
          irq_ena   <= writedata;
        end
        if (chipselect && write && (address == `IRQ_REDGE_OFFSET)) begin 
          irq_redge <= writedata;
        end
        if (chipselect && write && (address == `IRQ_FEDGE_OFFSET)) begin 
          irq_fedge <= writedata;
        end
      end       
    end
  
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
      
      /* Detect rising edge and falling edge if it's enabled */
      data_in_event <= (irq_redge & (data_in_r1 & ~data_in_r2))|
                       (irq_fedge & (~data_in_r1 & data_in_r2));
      
      /* 
         Latch the event, if the IRQ is enabled for this pin 
         or clear when we write 1 to the status
      */
      for(I=0;I<PORT_WIDTH;I=I+1)
        if(data_in_event[I]==1'b1 && irq_ena[I]==1'b1)
          irq_status[I] <= 1'b1;
        else if (chipselect && write && address == `IRQ_STATUS_OFFSET && writedata[I]==1'b1)
          irq_status[I] <= 1'b0;
    end 
  assign irq = | irq_status;
  
  /* 
  PWM values registers 
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
     Only 1 counter is running, the rest are just comparator
     PWM Rising edges of all pins are aligned
  */
  always@(posedge clk)
    begin 
      pwm_cntr <= pwm_cntr + 1;
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


