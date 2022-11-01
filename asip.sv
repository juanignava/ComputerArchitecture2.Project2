module asip
#(
    parameter V=192,
    parameter S=32
)
(
    // Clock 50Mhz
    input logic        clk,
	 
    // Neg reset
    input logic        rst,
	 
    // RGB switches
    input logic[1:0]   red_switches, green_switches, blue_switches,
	 
    // Gradient switch
    input logic        gtype_switch,
	 
    // VGA output
    output logic[23:0] rgb,
    output logic       v_sync,
    output logic       h_sync,
    output logic       vga_clk
);

    // RGBA selected values
    logic[S-1:0] R, G, B, A, gtype;

    // Instruction fetch signals
	 logic[S-1:0] pc_in, pc_fetch, instruction, pc_plus1;

    // Instruction decode signals
	 logic[S-1:0]  pc_decode;
	 logic[25:0]	imm;
	 logic[3:0]		regSrc1, regSrc2, regSrc3;
	 logic[1:0]    op, func;
	 logic 		   I, Vector;
	 
	 logic[V-1:0]	RSV1_decode, RSV2_decode, RSV3_decode;
	 logic[S-1:0] 	RSS1_decode, RSS2_decode, RSS3_decode;
	 logic[S-1:0]	imm_decode;
	 
	 logic[1:0] 	AluOp_decode, AluSrc3_decode;
	 logic			JumpI_decode, JumpCI_decode, JumpCD_decode, MemToReg_decode, MemWrite_decode, VectorOp_decode, AluSrc1_decode, AluSrc2_decode, RegVWrite_Decode, RegSWrite_decode, ImmSrc_decode;	
    

    // Execution signals
	 logic[S-1:0]  pc_ex;
	 logic[V-1:0]	RSV1_ex, RSV2_ex, RSV3_ex;
	 logic[S-1:0] 	RSS1_ex, RSS2_ex, RSS3_ex;
	 logic[S-1:0]	imm_ex;
	 
	 logic[3:0]		RD_ex;
	 logic[1:0] 	AluOp_ex, AluSrc3_ex;
	 logic			JumpI_ex, JumpCI_ex, JumpCD_ex, MemToReg_ex, MemWrite_x, VectorOp_ex, AluSrc1_ex, AluSrc2_ex, RegVWrite_ex, RegSWrite_ex;
	 
	 logic[V-1:0]  mux_result2, mux_result3, wd_ex, aluResult_ex;
	 logic[S-1:0]	pc_jump;
	 logic 			PCSrc_ex;
    

    // Memory signals
	 
	 logic[V-1:0]  wd_mem, aluResult_mem;
	 logic[3:0]		RD_mem;
	 logic			MemToReg_mem, MemWrite_mem, VectorOp_mem, RegVWrite_mem, RegSWrite_mem;
	 
	 logic[V-1:0]  data_mem;

    // Write back signals
	 
	 logic[V-1:0]  data_wb, aluResult_wb, muxResult_wb;
	 logic[3:0]		RD_wb;
	 logic			MemToReg_wb, RegVWrite_wb, RegSWrite_wb;
    

    //---------------------------------------------------------------------------------------------
    // Instruction fetch stage
    //---------------------------------------------------------------------------------------------
	
	// PC Register
		pc_register #(S) pc(
			 .clk(clk),
			 .clr(rst),
			 .load(1'b1),
			 .pc_in(pc_in),
			 .pc_out(pc_fetch)
		 );
		 
		 // Add 1 to pc to move to next instruction
		 // Compute next PC (32-bits)
		 adder #(S) addPC(
			  .A(pc_fetch),
			  .B(32'b1),
			  .C(pc_plus1)
		 );
		 
		 // Mux to select the PC (32-bits)
		 mux_2to1 #(S, S, S) pc_mux(
			  // PC counter from execution stage, used to jump
			  .A(pc_jump),
			  // Next PC
			  .B(pc_plus1),
			  // PC select based on jump unit output
			  .sel(PCSrc_ex),
			  .C(pc_in)
		 );
    

    //---------------------------------------------------------------------------------------------
    // Instruction Fetch/Instruction Decode pipeline
    //---------------------------------------------------------------------------------------------
    
		 segment_if_id(
		 .clk(clk),
		 .rst(rst),
		 .pc_out(pc_fetch),
		 .instruction(instruction),
		 .pc(pc_decode),
		 .op(op),
		 .func(func),
		 .I(I),
		 .V(Vector),
		 .RS1(regSrc1),
		 .RS3(regSrc3),
		 .RS2(regSrc2),
		 .imm(imm)
	);
   

    //---------------------------------------------------------------------------------------------
    // Instruction decode stage
    //---------------------------------------------------------------------------------------------
	 
    // Scalar register (32-bits)
	 
		 register_scalar #(S) reg_scalar(
		 
			 .RS1(regSrc1),
			 .RS2(regSrc2),
			 .RS3(regSrc3),
			 .RD(RD_wb),
			 .WD(muxResult_wb[31:0]),
			 .wr_enable(RegSWrite_wb),
			 .clk(clk),
			 .rst(rst),
			 .RD1(RSS1_decode),
			 .RD2(RSS2_decode),
			 .RD3(RSS3_decode)
		 );
    
    

    // Vectorial register (192-bits)
	 
		 register_vectorial #(V) reg_vectorial(
			 .RS1(regSrc1),
			 .RS2(regSrc2),
			 .RS3(regSrc3),
			 .RD(RD_wb),
			 .WD(muxResult_wb),
			 .wr_enable(RegVWrite_wb),
			 .clk(clk),
			 .rst(rst), 
			 .RD1(RSV1_decode),
			 .RD2(RSV2_decode),
			 .RD3(RSV3_decode)
		);  
   

    // Sign extension
	 
		 sign_extend sign_ext(
			 .num_in(imm),
			 .imm_src(ImmSrc_decode),
			 .num_out(imm_decode)
		 );
    

    // Control unit
	 
		 control_unit cu(
			 .instruction_type(op), 
			 .func(func),
			 .rst(rst), 
			 .imm(I), 
			 .vector(Vector),
			 .JumpI( JumpI_decode), 
			 .JumpCI(JumpCI_decode), 
			 .JumpCD(JumpCD_decode), 
			 .MemToReg(MemToReg_decode), 
			 .MemWrite(MemWrite_decode), 
			 .ImmSrc(ImmSrc_decode), 
			 .VectorOp(VectorOp_decode),
			 .ALUSrc1(AluSrc1_decode), 
			 .ALUSrc3(AluSrc3_decode), 
			 .RegVWrite(RegVWrite_Decode), 
			 .RegSWrite(RegSWrite_decode),
			 .ALUOp(AluOp_decode), 
			 .ALUSrc2(AluSrc2_decode)
		);

    //---------------------------------------------------------------------------------------------
    // Instruction Decode/Execution pipeline
    //---------------------------------------------------------------------------------------------
     

    //---------------------------------------------------------------------------------------------
    // Execution stage
    //---------------------------------------------------------------------------------------------
    // Mux ALU Operand 1 (192-bits)
    

    // Mux ALU Operand 2 (32-bits, 192-bits)
   

    // Mux Write Data (32-bits)
   

    // ALU with 6 lanes (192-bits, 32-bits)
    

    // PC/Imm adder
    

    // Jump logic
    

    //---------------------------------------------------------------------------------------------
    // Execution/Memory pipeline
    //---------------------------------------------------------------------------------------------
   
   

    //---------------------------------------------------------------------------------------------
    // Memory stage
    //---------------------------------------------------------------------------------------------
    // 32-bits scalar, 192-bits vec, 10 instructions, 30000 for ROM, 30000 for RAM, 5 registers for
    // switches
   

    //---------------------------------------------------------------------------------------------
    // Memory/Write Back pipeline
    //---------------------------------------------------------------------------------------------
   

    //---------------------------------------------------------------------------------------------
    // Write back stage
    //---------------------------------------------------------------------------------------------
    // Mux Write Back (32-bits)
   

    //---------------------------------------------------------------------------------------------
    // Switches mapping
    //---------------------------------------------------------------------------------------------
    // Mux red (32-bits, 32-bits)
   

    // Mux green (32-bits, 32-bits)
   

    // Mux blue (32-bits, 32-bits)
    

    // Mux transparency/alpha (32-bits, 32-bits)
    //mux_4to1 #(S, S) trans_mux(
    //    .A(VALUE1),
    //    .B(VALUE2),
    //    .C(VALUE3),
    //    .D(VALUE0),
    //    // Transparency/alpha switches
    //    .sel(rgba_switches[1:0]),
    //    .E(A)
    //);

    // Mux gradient selector (32-bits)
    //mux_2to1 #(S) gsel_mux(
    //    .A(TYPE1),
    //    .B(TYPE2),
    //    // Gradient selector
    //    .sel(gtype_switch),
    //    .C(gtype)
    //);
	 
endmodule : asip
