module PC(Clk, Rst, CurrPC, NextPC);
  
  //declare input and output signals
  input [15:0] CurrPC;
  input Clk, Rst;
  
  output reg [15:0] NextPC;
  
  always @(posedge Clk)
  begin
    if (!Rst)
      NextPC <= 0;
    else
      NextPC <= CurrPC + 1;
  end
    
endmodule