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
    input logic[7:0]   rgba_switches,
    // Gradient switch
    input logic        gtype_switch,
    // VGA output
    output logic[23:0] rgb,
    output logic       v_sync,
    output logic       h_sync,
    output logic       vga_clk
);
    // Local params for the RGBA intensity
    localparam VALUE0 = 0;
    localparam VALUE1 = 63;
    localparam VALUE2 = 191;
    localparam VALUE3 = 255;
    localparam TYPE1 = 0;
    localparam TYPE2 = 1;

    // RGBA selected values
    logic[S-1:0] R, G, B, A, gtype;

    // Instruction fetch signals
    logic[S-1:0] pc_in, pc_out, pc_plus, instruction;

    // Decode signals
    logic[S-1:0] pc_decode;
    logic[1:0]   type_op, func, ALUOp, ALUSrc2;
    logic        imm_type, vec_type, imm_src, JumpI, JumpCI, JumpCD, MemToReg, MemRead, MemWrite,
                 VectorOp, ALUSrc1, ALUSrc3, RegVWrite, RegSWrite;
    logic[3:0]   rs1, rs3, rs2;
    logic[25:0]  imm;
    logic[S-1:0] rd1, rd2, rd3, imm_ext;
    logic[V-1:0] rd1_vec, rd2_vec, rd3_vec;

    // Execution signals
    logic        JumpI_ex, JumpCI_ex, JumpCD_ex, MemToReg_ex, MemRead_ex, MemWrite_ex, VectorOp_ex,
                 ALUSrc1_ex, ALUSrc3_ex, RegVWrite_ex, RegSWrite_ex, flag_z, PCSrc_ex;
    logic[1:0]   ALUOp_ex, ALUSrc2_ex;
    logic[S-1:0] pc_ex, pc_jump;
    logic[V-1:0] RSS2_ex, RSS3_ex, RSS1_ex, RVS2_ex, RVS3_ex, RVS1_ex, imm_ext_ex, alu_op1,
                 alu_op2, write_data, alu_result;
    logic[3:0]   RR_ex;

    // Memory signals
    logic        MemToReg_mem, MemRead_mem, MemWrite_mem, VectorOp_mem,
                 RegVWrite_mem, RegSWrite_mem;
    logic[3:0]   RR_mem;
    logic[V-1:0] alu_result_mem, wd_mem, ram_data;

    // Write back signals
    logic[V-1:0] wd_wb, mem_wb, alu_result_wb;
    logic        MemToReg_wb, RegVWrite_wb, RegSWrite_wb;
    logic[3:0]   RR_wb;

    //---------------------------------------------------------------------------------------------
    // Instruction fetch stage
    //---------------------------------------------------------------------------------------------
    // Program counter (32-bits)
    pc_register #(S) pc(
        .clk(clk), 
        .clr(rst),
        .load(1'b1),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Compute next PC (32-bits)
    adder #(S) addp4(
        .A(pc_out),
        .B(32'b1),
        .C(pc_plus)
    );

    // Mux to select the PC (32-bits)
    mux_2to1 #(S) pc_mux(
        // PC counter from execution stage, used to jump
        .A(pc_jump),
        // Next PC
        .B(pc_plus),
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
        .pc_out(pc_out),
        .instruction(instruction),
        .pc(pc_decode),
        .instr_31_30(type_op),
        .instr_29_28(func),
        .instr_27(imm_type),
        .instr_26(vec_type),
        .instr_25_22(rs1),
        .instr_21_18(rs3),
        .instr_17_14(rs2),
        .instr_25_0(imm)
    );

    //---------------------------------------------------------------------------------------------
    // Instruction decode stage
    //---------------------------------------------------------------------------------------------
    // Scalar register (32-bits)
    register_scalar #(S) reg_scalar(
        .clk(clk),
        .rst(rst),
        .RS1(rs1),
        .RS2(rs2),
        .RS3(rs3),
        .RD(RR_wb),
        .WD(wd_wb),
        .wr_enable(RegSWrite_wb),
        .RD1(rd1),
        .RD2(rd2),
        .RD3(rd3)
    );

    // Vectorial register (192-bits)
    register_vectorial reg_vec(
        .clk(clk),
        .rst(rst),
        .RS1(rs1),
        .RS2(rs2),
        .RS3(rs3),
        .RD(RR_wb),
        .WD(wd_wb),
        .wr_enable(RegVWrite_wb),
        .RD1(rd1_vec),
        .RD2(rd2_vec),
        .RD3(rd3_vec)
    );

    // Sign extension
    sign_extend sign_ext(
        .num_in(imm),
        .imm_src(imm_src),
        .num_out(imm_ext)
    );

    // Control unit
    control_unit cu(
        .instruction_type(type_op),
        .func(func),
        .rst(rst),
        .imm(imm_type),
        .vector(vec_type),
        .JumpI(JumpI),
        .JumpCI(JumpCI),
        .JumpCD(JumpCD),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ImmSrc(imm_src),
        .VectorOp(VectorOp),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .ALUSrc3(ALUSrc3),
        .RegVWrite(RegVWrite),
        .RegSWrite(RegSWrite),
        .ALUOp(ALUOp)
    );

    //---------------------------------------------------------------------------------------------
    // Instruction Decode/Execution pipeline
    //---------------------------------------------------------------------------------------------
     segment_id_ex id_ex(
        .clk(clk),
        .rst(rst),
        .JumpI_in(JumpI),
        .JumpCI_in(JumpCI),
        .JumpCD_in(JumpCD),
        .MemToReg_in(MemToReg),
        .MemRead_in(MemRead),
        .MemWrite_in(MemWrite),
        .ALUOp_in(ALUOp),
        .VectorOp_in(VectorOp),
        .ALUSrc1_in(ALUSrc1),
        .ALUSrc2_in(ALUSrc2),
        .ALUSrc3_in(ALUSrc3),
        .pc_in(pc_decode),
        .RSS1_in({160'b0, rd1}),
        .RSS2_in({160'b0, rd2}),
        .RSS3_in({160'b0, rd3}),
        .RVS1_in(rd1_vec),
        .RVS2_in(rd2_vec),
        .RVS3_in(rd3_vec),
        .RR_in(rs1),
        .num_in(imm_ext),
        .RegVWrite_in(RegVWrite),
        .RegSWrite_in(RegSWrite),
        .JumpI_out(JumpI_ex),
        .JumpCI_out(JumpCI_ex),
        .JumpCD_out(JumpCD_ex),
        .MemToReg_out(MemToReg_ex),
        .MemRead_out(MemRead_ex),
        .MemWrite_out(MemWrite_ex),
        .ALUOp_out(ALUOp_ex),
        .VectorOp_out(VectorOp_ex),
        .ALUSrc1_out(ALUSrc1_ex),
        .ALUSrc2_out(ALUSrc2_ex),
        .ALUSrc3_out(ALUSrc3_ex),
        .pc_out(pc_ex),
        .RSS1_out(RSS1_ex),
        .RSS2_out(RSS2_ex),
        .RSS3_out(RSS3_ex),
        .RVS1_out(RVS1_ex),
        .RVS2_out(RVS2_ex),
        .RVS3_out(RVS3_ex),
        .RR_out(RR_ex),
        .num_out(imm_ext_ex),
        .RegVWrite_out(RegVWrite_ex),
        .RegSWrite_out(RegSWrite_ex)
    );

    //---------------------------------------------------------------------------------------------
    // Execution stage
    //---------------------------------------------------------------------------------------------
    // Mux ALU Operand 1 (192-bits)
    mux_2to1 #(V) alu_op1_mux(
        // Scalar register 2 output
        .A({160'b0, RSS2_ex}),
        // Vectorial register 2 output
        .B(RVS2_ex),
        // Select with ALUSrc3
        .sel(ALUSrc3_ex),
        .C(alu_op1)
    );

    // Mux ALU Operand 2 (32-bits, 192-bits)
    mux_4to1 #(S, V) alu_op2_mux(
        // Scalar register 3 output
        .A(RSS3_ex),
        // Imm extension
        .B(imm_ext_ex),
        // Scalar register 1 output
        .C(RSS1_ex),
        // Vectorial register 3 output
        .D(RVS3_ex),
        // Select with ALUSrc2
        .sel(ALUSrc2_ex),
        .E(alu_op2)
    );

    // Mux Write Data (32-bits)
    mux_2to1 #(S) wd_mux(
        // Vectorial register 1 output
        .A(RVS1_ex),
        // Scalar register 1 output
        .B(RSS1_ex),
        // Select with ALUSrc1
        .sel(ALUSrc1_ex),
        .C(write_data)
    );

    // ALU with 6 lanes (192-bits, 32-bits)
    alu_6lanes #(V, S) alu(
        .A(alu_op1),
        .B(alu_op2),
        .op(ALUOp_ex),
        .sel(VectorOp_ex),
        .C(alu_result),
        .flagZ(flag_z)
    );

    // PC/Imm adder
    adder add(
        .A(pc_ex),
        .B(imm_ext_ex),
        .C(pc_jump)
    );

    // Jump logic
    jump_unit jump(
        .FlagZ(flag_z),
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
        .MemRead_in(MemRead_ex),
        .MemWrite_in(MemWrite_ex),
        .VectorOp_in(VectorOp_ex),
        .RegSWrite_in(RegSWrite_ex),
        .RegVWrite_in(RegVWrite_ex),
        .alu_in(alu_result),
        .mux1_in({160'b0, write_data}),
        .RR_in(RR_ex),
        .MemToReg_out(MemToReg_mem),
        .MemRead_out(MemRead_mem),
        .MemWrite_out(MemWrite_mem),
        .VectorOp_out(VectorOp_mem),
        .RegSWrite_out(RegSWrite_mem),
        .RegVWrite_out(RegVWrite_mem),
        .alu_out(alu_result_mem),
        .mux1_out(wd_mem),
        .RR_out(RR_mem)
    );

    //---------------------------------------------------------------------------------------------
    // Memory stage
    //---------------------------------------------------------------------------------------------
    // 32-bits scalar, 192-bits vec, 10 instructions, 30000 for ROM, 30000 for RAM, 5 registers for
    // switches
    memoryController #(S, V, 1000, 30000, 30000, 15) mem_controller (
        .clk(clk),
        .we(MemWrite_mem),
        .VecOp(VectorOp_mem),
        .switchStart(1'b0),
        .pc(pc_out),
        .address(alu_result_mem[S-1:0]),
        .switch_regs({
            {30'b0, rgba_switches[0]},
            {30'b0, rgba_switches[1]},
            {30'b0, rgba_switches[2]},
            {30'b0, rgba_switches[3]},
            {30'b0, rgba_switches[4]},
            {30'b0, rgba_switches[5]},
            {30'b0, rgba_switches[6]},
            {30'b0, rgba_switches[7]},
            {30'b0, gtype_switch},
            R,
            G,
            B,
            R,
            G,
            B
        }),
        .wd(wd_mem),
        .instruction(instruction),
        .rd(ram_data)
    );

    //---------------------------------------------------------------------------------------------
    // Memory/Write Back pipeline
    //---------------------------------------------------------------------------------------------
    segment_mem_wb mem_web(
        .clk(clk),
        .rst(rst),
        .MemToReg_in(MemToReg_mem),
        .RegSWrite_in(RegSWrite_mem),
        .RegVWrite_in(RegVWrite_mem),
        .mem_in(ram_data),
        .alu_in(alu_result_mem),
        .RR_in(RR_mem),								
        .MemToReg_out(MemToReg_wb),
        .RegSWrite_out(RegSWrite_wb),
        .RegVWrite_out(RegVWrite_wb),
        .mem_out(mem_wb),
        .alu_out(alu_result_wb),
        .RR_out(RR_wb)
    );

    //---------------------------------------------------------------------------------------------
    // Write back stage
    //---------------------------------------------------------------------------------------------
    // Mux Write Back (32-bits)
    mux_2to1 #(S) wb_mux(
        .A(mem_wb),
        .B(alu_result_wb),
        .sel(MemToReg_wb),
        .C(wd_wb)
    );

    //---------------------------------------------------------------------------------------------
    // Switches mapping
    //---------------------------------------------------------------------------------------------
    // Mux red (32-bits, 32-bits)
    mux_4to1 #(S, S) red_mux(
        .A(VALUE1),
        .B(VALUE2),
        .C(VALUE3),
        .D(VALUE0),
        // Red switches
        .sel(rgba_switches[7:6]),
        .E(R)
    );

    // Mux green (32-bits, 32-bits)
    mux_4to1 #(S, S) green_mux(
        .A(VALUE1),
        .B(VALUE2),
        .C(VALUE3),
        .D(VALUE0),
        // Green switches
        .sel(rgba_switches[5:4]),
        .E(G)
    );

    // Mux blue (32-bits, 32-bits)
    mux_4to1 #(S, S) blue_mux(
        .A(VALUE1),
        .B(VALUE2),
        .C(VALUE3),
        .D(VALUE0),
        // Blue switches
        .sel(rgba_switches[3:2]),
        .E(B)
    );

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
