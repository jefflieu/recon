/*
  Project: RECON 2017
  Author: Jeff Lieu <lieumychuong@gmail.com>
  Description: Timer module to support delay function
*/

module buttonDebouncer
    #(  /* Debounce time - Count in nanosecond */
        parameter pDEBOUNCE_PERIOD  = 100_000_000,
        /* Clock Input period - Count in nanosecond */
        parameter pCLKIN_PERIOD     = 20,
        /* Size of  button array */
        parameter pARRAY_SIZE       = 2,
        /* 
          Polarity configures the edge detection which edge would cause a tick  
          Buttons are default to active low, which means a "Button Down" event is generated when the signal level fall from High to Low 
          Active high (pPOLARITY = 1) means a Button Down when the signal level changes from Low to High
        */
        parameter pPOLARITY         = 0)(
  
  input                                     clk ,
  input       [           pARRAY_SIZE-1:0]  buttons , 
  output      [           pARRAY_SIZE-1:0]  buttonState,
  output  reg [           pARRAY_SIZE-1:0]  buttonUpTick,
  output  reg [           pARRAY_SIZE-1:0]  buttonDwTick
);


  reg [pARRAY_SIZE-1:0] buttonsReg0;
  reg [pARRAY_SIZE-1:0] buttonsReg1;
  reg [pARRAY_SIZE-1:0] buttonsReg2; 
  /* We share the counter, if buttons are pressed together, 
  we need to wait for all buttons to settle */
  reg [23:0] debouncer;
  reg [pARRAY_SIZE-1:0] buttonsDebounced;
  reg [pARRAY_SIZE-1:0] buttonsDebouncedReg;

  reg [pARRAY_SIZE-1:0] buttonTck;
  integer I;


  always@(posedge clk)
  begin 
    buttonsReg0 <= buttons;
    buttonsReg1 <= buttonsReg0;
    buttonsReg2 <= buttonsReg1;
    
    if (buttonsReg2 != buttonsReg1) 
      begin 
        debouncer <= pDEBOUNCE_PERIOD/pCLKIN_PERIOD;
      end 
    else if (debouncer != 0) 
      begin 
        debouncer <= debouncer - 1;
      end
    else begin
      buttonsDebounced <= buttonsReg2;
    end
    
    buttonsDebouncedReg <= buttonsDebounced;
    
    for(I = 0; I<pARRAY_SIZE; I = I + 1)
    begin
      if (pPOLARITY==0) begin 
        buttonDwTick[I] <= buttonsDebouncedReg[I] & (~buttonsDebounced[I]);
        buttonUpTick[I] <= ~buttonsDebouncedReg[I] & buttonsDebounced[I];
        end 
      else begin 
        buttonUpTick[I] <= buttonsDebouncedReg[I] & (~buttonsDebounced[I]);
        buttonDwTick[I] <= ~buttonsDebouncedReg[I] & buttonsDebounced[I];
      end 
    end 
    
  end 
  
  assign buttonTick   = buttonTck;
  assign buttonState  = buttonsDebouncedReg;

endmodule 


