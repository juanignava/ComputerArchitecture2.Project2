module sign_extend
(
    input  logic[25:0] num_in,
    input  logic       imm_src,
    output logic[31:0] num_out
);

    always_comb begin
        case(imm_src)
            // 27-bit unsigned immediate
            1'b0: num_out = {{6{num_in[25]}}, num_in};
            // 17-bit unsigned immediate
            1'b1: num_out = {{14{num_in[17]}}, num_in[17:0]};
            default: num_out = 32'b0; // undefined
        endcase
    end
endmodule : sign_extend
