module asip
#(
    parameter V=192,
    parameter S=32,
	 parameter SIZE_INS = 1000,
	 parameter SIZE_ROM = 30000,
	 parameter SIZE_RAM = 30030
)
(
    // Clock 50Mhz
    input logic        clk,
	 
    // Neg reset
    input logic        rst,
	 
    // RGB switches
    input logic[1:0]   red_switches, green_switches, blue_switches, tran_switches,
	 
    // Gradient switch
    input logic        gtype_switch,
	 
	 // Switch start
	 input logic switchStart,
	 
    // VGA output
    output logic[7:0] r, g, b,
    output logic       vsync, hsync, n_sync, n_blanc, n25MHZCLK
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
	 logic			JumpI_decode, JumpCI_decode, JumpCD_decode, MemToReg_decode, MemWrite_decode, VectorOp_decode, AluSrc1_decode, AluSrc2_decode, RegVWrite_decode, RegSWrite_decode, ImmSrc_decode;	
    

    // Execution signals
	 logic[S-1:0]  pc_ex;
	 logic[V-1:0]	RSV1_ex, RSV2_ex, RSV3_ex;
	 logic[S-1:0] 	RSS1_ex, RSS2_ex, RSS3_ex;
	 logic[S-1:0]	imm_ex;
	 
	 logic[3:0]		RD_ex;
	 logic[1:0] 	AluOp_ex, AluSrc3_ex;
	 logic			JumpI_ex, JumpCI_ex, JumpCD_ex, MemToReg_ex, MemWrite_ex, VectorOp_ex, AluSrc1_ex, AluSrc2_ex, RegVWrite_ex, RegSWrite_ex;
	 
	 logic[V-1:0]  mux_result1, mux_result2, mux_result3, wd_ex, aluResult_ex;
	 logic[S-1:0]	pc_jump;
	 logic 			PCSrc_ex, flagZ;
    

    // Memory signals
	 
	 logic[V-1:0]  wd_mem, aluResult_mem;
	 logic[3:0]		RD_mem;
	 logic			MemToReg_mem, MemWrite_mem, VectorOp_mem, RegVWrite_mem, RegSWrite_mem;
	 
	 logic[V-1:0]  data_mem;

    // Write back signals
	 
	 logic[V-1:0]  data_wb, aluResult_wb, muxResult_wb;
	 logic[3:0]		RD_wb;
	 logic			MemToReg_wb, RegVWrite_wb, RegSWrite_wb;
	 
	 // vga signals
	 logic [9:0] x, y;
	 logic [31:0] address, prev_address;
	 logic [191:0] data;
	 logic [7:0] r_siguiente,g_siguiente,b_siguiente;
	 logic video_on;
    

    //---------------------------------------------------------------------------------------------
    // Instruction fetch stage
    //---------------------------------------------------------------------------------------------
	
	// PC Register
		pc_register #(S) pc(
			 .clk(clk),
			 .clr(~rst),
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
			  .A(pc_plus1),
			  // Next PC
			  .B(pc_jump),
			  // PC select based on jump unit output
			  .sel(PCSrc_ex),
			  .C(pc_in)
		 );
    

    //---------------------------------------------------------------------------------------------
    // Instruction Fetch/Instruction Decode pipeline
    //---------------------------------------------------------------------------------------------
    
		 segment_if_id if_id(
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
			 .ALUSrc2(AluSrc2_decode), 
			 .RegVWrite(RegVWrite_decode), 
			 .RegSWrite(RegSWrite_decode),
			 .ALUOp(AluOp_decode), 
			 .ALUSrc3(AluSrc3_decode)
		);

    //---------------------------------------------------------------------------------------------
    // Instruction Decode/Execution pipeline
    //---------------------------------------------------------------------------------------------
	 
		segment_id_ex id_ex(
			 .clk(clk),
			 .rst(rst),
			 .JumpI_in(JumpI_decode),
			 .JumpCI_in(JumpCI_decode),
			 .JumpCD_in(JumpCD_decode),
			 .MemToReg_in(MemToReg_decode),
			 .MemWrite_in(MemWrite_decode),
			 .ALUOp_in(AluOp_decode),
			 .VectorOp_in(VectorOp_decode),
			 .ALUSrc1_in(AluSrc1_decode),
			 .ALUSrc2_in(AluSrc2_decode),
			 .ALUSrc3_in(AluSrc3_decode),
			 .pc_in(pc_decode),
			 .RSS2_in(RSS2_decode),
			 .RSS3_in(RSS3_decode),
			 .RSS1_in(RSS1_decode),
			 .RVS2_in(RSV2_decode),
			 .RVS3_in(RSV3_decode),
			 .RVS1_in(RSV1_decode),
			 .RD_in(regSrc1),
			 .num_in(imm_decode),
			 .RegSWrite_in(RegSWrite_decode), 
			 .RegVWrite_in(RegVWrite_decode), 
			 .JumpI_out(JumpI_ex),
			 .JumpCI_out(JumpCI_ex),
			 .JumpCD_out(JumpCD_ex),
			 .MemToReg_out(MemToReg_ex),
			 .MemWrite_out(MemWrite_ex),
			 .ALUOp_out(AluOp_ex),
			 .VectorOp_out(VectorOp_ex),
			 .ALUSrc1_out(AluSrc1_ex),
			 .ALUSrc2_out(AluSrc2_ex),
			 .ALUSrc3_out(AluSrc3_ex),
			 .pc_out(pc_ex),
			 .RSS2_out(RSS2_ex),
			 .RSS3_out(RSS3_ex),
			 .RSS1_out(RSS1_ex),
			 .RVS2_out(RSV2_ex),
			 .RVS3_out(RSV3_ex),
			 .RVS1_out(RSV1_ex),
			 .RD_out(RD_ex),
			 .num_out(imm_ex),
			 .RegSWrite_out(RegSWrite_ex),
			 .RegVWrite_out(RegVWrite_ex)
		);

    //---------------------------------------------------------------------------------------------
    // Execution stage
    //---------------------------------------------------------------------------------------------
    // Muxes
	 
		 mux_2to1 #(S, V, V) AluSrc2_mux(
			  .A(RSS2_ex), 
			  .B(RSV2_ex),
			  .sel(AluSrc2_ex),
			  .C(mux_result2)
		 );
		 
		 mux_2to1 #(S, V, V) AluSrc1_mux(
			  .A(RSS1_ex), 
			  .B(RSV1_ex),
			  .sel(AluSrc1_ex),
			  .C(mux_result1)
		 );
		 
		 mux_4to1 #(S, V) AluSrc3_mux(
			  .A(RSV3_ex),
			  .B(RSS3_ex),
			  .C(imm_ex),
			  .D(RSS1_ex),
			  .sel(AluSrc3_ex),
			  .E(mux_result3)
		 );

    // ALU with 6 lanes (192-bits, 32-bits)
	 
		 alu_6lanes #(V, S) alu(
			  .A(mux_result2),
			  .B(mux_result3),
			  .op(VectorOp_ex),
			  .sel(AluOp_ex),
			  .C(aluResult_ex),
			  .flagZ(flagZ)
		 );
    

    // PC/Imm adder
	 
		 adder #(S) adderEx(
			  .A(pc_ex),
			  .B(imm_ex),
			  .C(pc_jump)
		 );
    

    // Jump logic
	 
		 jump_unit jump(
			  .FlagZ(flagZ),
			  .JumpCD(JumpCD_ex),
			  .JumpCI(JumpCI_ex),
			  .JumpI(JumpI_ex),
			  .PCSource(PCSrc_ex)
		 );
		 

    //---------------------------------------------------------------------------------------------
    // Execution/Memory pipeline
    //---------------------------------------------------------------------------------------------
		
		segment_ex_mem ex_mem(
			 .clk(clk),
			 .rst(rst),
			 .MemToReg_in(MemToReg_ex),
			 .MemWrite_in(MemWrite_ex),
			 .VectorOp_in(VectorOp_ex),
			 .RegSWrite_in(RegSWrite_ex),
			 .RegVWrite_in(RegVWrite_ex),
			 .alu_in(aluResult_ex),
			 .mux1_in(mux_result1),
			 .RD_in(RD_ex),
			 .MemToReg_out(MemToReg_mem),
			 .MemWrite_out(MemWrite_mem),
			 .VectorOp_out(VectorOp_mem),
			 .RegSWrite_out(RegSWrite_mem),
			 .RegVWrite_out(RegVWrite_mem),
			 .alu_out(aluResult_mem),
			 .mux1_out(wd_mem),
			 .RD_out(RD_mem)
		);
		
    //---------------------------------------------------------------------------------------------
    // Memory stage
    //---------------------------------------------------------------------------------------------
	 
		 memoryController #(S, V, SIZE_INS, SIZE_ROM, SIZE_RAM) memory(
			 .clk(clk),
			 .rst(rst),
			 .we(MemWrite_mem),
			 .VecOp(VectorOp_mem),
			 .switchStart(switchStart),
			 .pc(pc_fetch),
			 .address(aluResult_mem[31:0]),
			 .wd(wd_mem),
			 .instruction(instruction),
			 .rd(data_mem),
			 .red_switches(red_switches),
			 .green_switches(green_switches),
			 .blue_switches(blue_switches),
			 .tran_switches(tran_switches),
			 .gtype_switch(gtype_switch)
	);
   

    //---------------------------------------------------------------------------------------------
    // Memory/Write Back pipeline
    //---------------------------------------------------------------------------------------------
	 
		 segment_mem_wb mem_wb(
			 .clk(clk),
			 .rst(rst),
			 .MemToReg_in(MemToReg_mem),
			 .RegSWrite_in(RegSWrite_mem),
			 .RegVWrite_in(RegVWrite_mem),
			 .mem_in(data_mem),
			 .alu_in(aluResult_mem),
			 .RD_in(RD_mem),								
			 .MemToReg_out(MemToReg_wb),
			 .RegSWrite_out(RegSWrite_wb),
			 .RegVWrite_out(RegVWrite_wb),
			 .mem_out(data_wb),
			 .alu_out(aluResult_wb),
			 .RD_out(RD_wb)
		);

    //---------------------------------------------------------------------------------------------
    // Write back stage
    //---------------------------------------------------------------------------------------------
		 mux_2to1 #(V, V, V) wb_mux(
			  .A(aluResult_wb), 
			  .B(data_wb),
			  .sel(MemToReg_wb),
			  .C(muxResult_wb)
		 );
   

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
	 
	 //---------------------------------------------------------------------------------------------
    // VGA controller
    //---------------------------------------------------------------------------------------------
	 
	 HV_sync 		vga_sync_unit 		(.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .enable(video_on), .clk_out(n25MHZCLK), .x(x), .y(y));
		 
	 // ram memory (read only)
	dmem_rom2 #(S, V, SIZE_RAM) dmem_rom2(
		.address(address),
		.rd(data)
	);
	
	
	
	 always_ff @(posedge n25MHZCLK)
		begin
			// calculate the address
			if (y < 100 && x < 100) begin
				address = y * 300 + x*3;
				prev_address = address;
				r_siguiente = data[7:0];
				g_siguiente = data[39:32];
				b_siguiente = data[71:64];
			end
			else begin
				address = prev_address;
				r_siguiente = 8'd0;
				g_siguiente = 8'd0;
				b_siguiente = 8'd0;
			end
				
			
				
		end
	
	
	assign r = (video_on) ? r_siguiente : 8'b0;
	assign g = (video_on) ? g_siguiente : 8'b0;
	assign b = (video_on) ? b_siguiente : 8'b0;
	assign n_sync  =  1'b0;
	assign n_blanc =  1'b1;
	 
	 
endmodule : asip
