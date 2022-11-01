module segment_if_id
(
    input  logic       clk,
    input  logic       rst,
    input  logic[31:0] pc_out,
    input  logic[31:0] instruction,
    output logic[31:0] pc,
    output logic[1:0]  op,
    output logic[1:0]  func,
    output logic       I,
    output logic       V,
    output logic[3:0]  RS1,
    output logic[3:0]  RS3,
    output logic[3:0]  RS2,
    output logic[25:0] imm
);
            
    always_ff@(negedge clk, posedge rst) begin
        if (rst) begin
            pc = 0;
            op = 0;
            func = 0;
            I = 0;
            V = 0;
            RS1 = 0;
            RS2 = 0;
            RS3 = 0;
            imm = 0;
        end else begin
            pc = pc_out;
            op = instruction[31:30];				
            func= instruction[29:28];				
            I = instruction[27];
            V = instruction[26];
            RS1 = instruction[25:22];				
            RS3 = instruction[21:18];				
            RS2 = instruction[17:14];				
            imm = instruction[25:0];
        end
    end
endmodule : segment_if_id

