
module metaSync (iClk, iRst,in,out);
parameter pSTAGE = 3;
parameter pRSTVAL = 1'b0;
parameter pRESET = 1'b0;
input iClk;
input in;
input iRst;
output out;

reg [pSTAGE-1:0] dff;
integer I;
wire reset;

assign reset = iRst^pRESET;

always@(posedge iClk or posedge iRst)
  if (iRst)
    begin 
      for(I=0;I<pSTAGE;I=I+1)
      begin 
        dff[I] <= pRSTVAL;
      end
    end 
  else 
    begin 
      dff <= {dff[pSTAGE-2:0], in};  
    end
  

  assign out = dff[pSTAGE-1];
endmodule 
