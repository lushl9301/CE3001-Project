module CPU(Clk, Rst);
  
  input Clk, Rst;
  
// Buffer value and usage
/******************************************
  
  bufNum 	signalName 	signalWidth
  =====Fetch=====
  
  =====Decode=====
  0 	     Instruction	16
  1 	     CurrPC		    16
  
  2 	     ALUOp		     3
  3 	     Signal      (0:10)
	        MemEnab     (11)
	        MemWrite    (12)
	        WriteEn		   (13)
	                    14
  
  6	      Sign_Ext8	  16
  7	      Sign_Ext12	 16
  =====Execute=====
  4	      RData1		    16
  5	      RData2		    16
  8       MuxOut[5]   16
  =====Mem Access=====
  9	      FLAG		      3
  10	     ALUOut		    16
  =====Write Back=====
  
******************************************/
  
  integer i;
  
  //reg [15:0] IF_Buff [0:15];
  reg [15:0] ID_Buff [0:15];
  reg [15:0] EX_Buff [0:15];
  reg [15:0] MEM_Buff [0:15];
  
  reg [15:0] Spec_Addr_Reg;
  
  wire [15:0] ID_Buff_0_wire;
  wire [15:0] ID_Buff_1_wire;
  
  wire [15:0] EX_Buff_4_wire;
  wire [15:0] EX_Buff_5_wire;
  
  wire [15:0] MEM_Buff_9_wire;
  wire [15:0] MEM_Buff_10_wire;
  
  wire [15:0] WB_Buff_11_wire;
  
  wire [15:0] MuxOut [0:10];
  wire [15:0] AddOut [0:1];
  wire [15:0] LHBOut;
    
  //Multiplexer Implementation
  assign MuxOut[0] = ID_Buff[3][0]?MuxOut[1]:AddOut[0];
  assign MuxOut[1] = ID_Buff[3][1]?EX_Buff_5_wire:MuxOut[2];
  assign MuxOut[2] = ID_Buff[3][2]?AddOut[1]:ID_Buff[7]; 
  assign MuxOut[3] = MEM_Buff[3][3]?16'd15:MEM_Buff[0][11:8];
  assign MuxOut[4] = ID_Buff[3][4]?EX_Buff_4_wire:ID_Buff[6];
  assign MuxOut[5] = ID_Buff[3][5]?EX_Buff_5_wire:ID_Buff[6];
  assign MuxOut[6] = EX_Buff[3][6]?EX_Buff[1]:MuxOut[10];  
  assign MuxOut[7] = MEM_Buff[3][7]?WB_Buff_11_wire:MuxOut[6];
  assign MuxOut[8] = ID_Buff[3][8]?ID_Buff[0][11:8]:ID_Buff[0][3:0];
  assign MuxOut[9] = ID_Buff[3][9]?Spec_Addr_Reg:MuxOut[0];
  assign MuxOut[10] = EX_Buff[3][10]?LHBOut:MEM_Buff_10_wire;
  
  //Implement addition logic
  //assign AddOut[0] = IF_Buff[1] + 16'b1;
  assign AddOut[1] = ID_Buff[1] + ID_Buff[6];
  
  //Implement or logic
  assign LHBOut = {EX_Buff_5_wire[7:0],ID_Buff[6][7:0]);
  
  //Module Instantiation
  /**********Instruction Fectch**********/
  I_memory A0(.address(MuxOut[9]), .data_out(ID_Buff_0_wire), .Clk(Clk), .Rst(Rst));
  PC A1(.Clk(Clk), .Rst(Rst), .CurrPC(MuxOut[9]), .NextPC(ID_Buff_1_wire));
  
  /**********Instruction Decode**********/
  control A2(.OpCode(ID_Buff_0_wire[15:12]), .Cond(ID_Buff_0_wire[3:0]), .Flag(MEM_Buff_9_wire), .ALUOp(ID_Buff[2]), 
             .WriteEn(ID_Buff[3][13]), .MemEnab(ID_Buff[3][11]), .MemWrite(ID_Buff[3][12]), .Signal(ID_Buff[3][10:0]));
  Reg_File A3(.RAddr1(ID_Buff_0_wire[7:4]), .RAddr2(MuxOut[8]), .WAddr(MuxOut[3]), .WData(MuxOut[7]), .Wen(MEM_Buff[3][13]), 
             .Clock(Clk), .Reset(Rst), .RData1(EX_Buff_4_wire), .RData2(EX_Buff_5_wire));
  
  always@(posedge Clk) begin
    ID_Buff[6] <= ID_Buff_0_wire[7:0];    // should be 2's complement
    ID_Buff[7] <= ID_Buff_0_wire[11:0];   // should be 2's complement
  end
  
  /**********Execute***********/
  always@(posedge Clk) begin
    EX_Buff[8] <= MuxOut[5];
  end
  
  alu A4(.A(MuxOut[4]), .B(MuxOut[5]), .lastFlag(MEM_Buff_9_wire), .imm(ID_Buff[0][3:0]), .clk(Clk), .out(MEM_Buff_10_wire), .flag(MEM_Buff_9_wire));
  
  /**********Memory Access************/
  D_memory A5(.address(MEM_Buff_10_wire), .data_in(EX_Buff[8]), .data_out(WB_Buff_11_wire), .clk(Clk), .rst(Rst), .write_en(EX_Buff[3][12]));
  
  always@(posedge Clk) begin
  
  // IF -> ID
  
  ID_Buff[0] <= ID_Buff_0_wire;
  ID_Buff[1] <= ID_Buff_1_wire;
  
  // ID -> EX
  
  for (i = 0; i <= 3; i = i+1)
    EX_Buff[i] <=  ID_Buff[i];
    
  EX_Buff[4] <= EX_Buff_4_wire;
  EX_Buff[5] <= EX_Buff_5_wire;
  
  for (i = 6; i <= 7; i = i+1)
    EX_Buff[i] <=  ID_Buff[i];
  
  // EX -> MEM
  
  for (i = 0; i <= 8; i = i+1)
    MEM_Buff[i] <=  EX_Buff[i];
    
  MEM_Buff[9] <= MEM_Buff_9_wire;
  MEM_Buff[10] <= MEM_Buff_10_wire;
  
  end  
  
endmodule
            
