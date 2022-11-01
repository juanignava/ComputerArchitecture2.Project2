module mux_4to1
#(
    parameter S=32,
    parameter V=192
) 
(
	 input  logic[V-1:0] A,
    input  logic[S-1:0] B, C, D,
    
    input  logic[1:0]   sel,
    output logic[V-1:0] E
);
    always_comb begin
        case (sel)
            // 27-bit unsigned immediate
            2'b00: E = A;
            // 01 case:
            2'b01: E = B;
            // 10 case:
            2'b10: E = C;
            // 11 case:
            2'b11: E = D;
            default: E = 192'b0; // undefined
        endcase
    end
endmodule : mux_4to1
