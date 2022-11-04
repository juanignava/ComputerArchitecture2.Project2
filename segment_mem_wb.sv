 module segment_mem_wb
(
    input  logic        clk,
    input  logic        rst,
    input  logic        MemToReg_in,
    input  logic        RegSWrite_in,
    input  logic        RegVWrite_in,
    input  logic[191:0] mem_in,
    input  logic[191:0] alu_in,
    input  logic[3:0]   RD_in,								
    output logic        MemToReg_out,
    output logic        RegSWrite_out,
    output logic        RegVWrite_out,
    output logic[191:0] mem_out,
    output logic[191:0] alu_out,
    output logic[3:0]   RD_out
);
    always_ff@(negedge clk, posedge rst) begin
        if (rst) begin
            MemToReg_out = 0;
            RegSWrite_out = 0;
            RegSWrite_out = 0;
            mem_out = 0;
            alu_out = 0;
            RD_out = 0;
        end else begin
            MemToReg_out = MemToReg_in;
            RegSWrite_out = RegSWrite_in;
            RegVWrite_out = RegVWrite_in;
            mem_out = mem_in;
            alu_out = alu_in;
            RD_out = RD_in;
        end
    end
endmodule : segment_mem_wb
