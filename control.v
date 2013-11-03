module control(OpCode,Cond, Flag, ALUOp, WriteEn, MemEnab, MemWrite, Signal);

  //declare input and output signal
  input [3:0] OpCode;
  input [2:0] Cond;
  input [2:0] Flag;
  
  
  output MemEnab, MemWrite, WriteEn;
  output reg [2:0] ALUOp;
  output reg [10:0] Signal;
  
  wire N,V,Z;
  wire BS;// branch successful or not
  
  

  
  always @(OpCode or Cond or Flag)
  begin
    
    N = Flag[2];
    V = Flag[1];
    Z = Flag[0];
    
     
   case (OpCode)
     
      // ADD
      4'b0000: Signal   = 10'b00000110110;
               ALUOp    = 3'b000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SUB
      4'b0001: Signal   = 10'b00000110110;
               ALUOp    = 3'b001;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //AND         
      4'b0010: Signal   = 10'b00000110110;
               ALUOp    = 3'b010;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //OR        
      4'b0011: Signal   = 10'b00000110110;
               ALUOp    = 3'b011;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SLL         
      4'b0100: Signal   = 10'b00000010110;
               ALUOp    = 3'b100;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SRL        
      4'b0101: Signal   = 10'b00000010110;
               ALUOp    = 3'b101;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //SRA         
      4'b0110: Signal   = 10'b00000010110;
               ALUOp    = 3'b110;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //RL
      4'b0111: Signal   = 10'b00000010110;
               ALUOp    = 3'b111;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b1;
               
      //LW         
      4'b1000: Signal   = 10'b00010010110;
               WriteEn  = 1'b1;
               MemEnab  = 1'b1;
               MemWrite = 1'b0;
               
      //SW         
      4'b1001: Signal   = 10'b00010010110;
               WriteEn  = 1'b0;
               MemEnab  = 1'b1;
               MemWrite = 1'b1;
               
      //LHB        
      4'b1010: Signal   = 10'b10100000000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //LLB         
      4'b1011: Signal   = 10'b00000000000;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //B  
      //N = Flag[2];
      //V = Flag[1];
      //Z = Flag[0];       
      4'b1100: case(Cond)
      
                 3'b000:  BS = ( Z == 1)? 1'b1:1'b0; //Equal
                 3'b001:  BS = ( Z == 0)? 1'b1:1'b0; //Not Equal
                 3'b010:  BS = (Z == 0 && N == 0)? 1'b1:1'b0; // Greater Than
                 3'b011:  BS = (N == 1)? 1'b1:1'b0; // Less Than      
                 3'b100:  BS = (Z==1||(Z == 0 && N == 0))? 1'b1:1'b0; //Greater ot Equal        
                 3'b101:  BS = (Z==1||N == 1)? 1'b1:1'b0; //Less or Equal
                 3'b110:  BS = (V == 1)? 1'b1:1'b0;  //Overflow
                 3'b111:  BS = 1'b1; // True
                 default: BS = 1'b0; // False
               
               endcase 
      //JAL         
      4'b1101: Signal   = 10'b00101111101;
               WriteEn  = 1'b1; 
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //JR         
      4'b1110: Signal   = 10'b00101111111;
               WriteEn  = 1'b0; 
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
               
      //EXEC : EXEC(Next)to be completed      
      4'b1111: Signal   = 10'b00100110111;
               WriteEn  = 1'b1;
               MemEnab  = 1'b0;
               MemWrite = 1'b0;
                   

   endcase
   
   if (BS == 1) begin
      Signal   = 10'b00000110001;
      WriteEn  = 1'b0;
      MemEnab  = 1'b0;
      MemWrite = 1'b0;
    end else 
      Signal   = 10'b00000110000;
      WriteEn  = 1'b0;
      MemEnab  = 1'b0;
      MemWrite = 1'b0;
    end
   
   
  end
  
endmodule
 