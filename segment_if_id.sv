module segment_if_id
(
    input  logic       clk,
    input  logic       rst,
    input  logic[31:0] pc_out,
    input  logic[31:0] instruction,
    output logic[31:0] pc,
    output logic[1:0]  instr_31_30,
    output logic[1:0]  instr_29_28,
    output logic       instr_27,
    output logic       instr_26,
    output logic[3:0]  instr_25_22,
    output logic[3:0]  instr_21_18,
    output logic[3:0]  instr_17_14,
    output logic[25:0] instr_25_0
);
            
    always_ff@(negedge clk, posedge rst) begin
        if (rst) begin
            pc = 0;
            instr_31_30 = 0;
            instr_29_28 = 0;
            instr_27 = 0;
            instr_26 = 0;
            instr_25_22 = 0;
            instr_21_18 = 0;
            instr_17_14 = 0;
            instr_25_0 = 0;
        end else begin
            pc = pc_out;
            instr_31_30 = instruction[31:30];				
            instr_29_28 = instruction[29:28];				
            instr_27 = instruction[27];
            instr_26 = instruction[26];
            instr_25_22 = instruction[25:22];				
            instr_21_18 = instruction[21:18];				
            instr_17_14 = instruction[17:14];				
            instr_25_0 = instruction[25:0];
        end
    end
endmodule : segment_if_id
