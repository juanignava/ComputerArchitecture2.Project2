module mux_2to1
#(
    parameter E1=192,
	 parameter E2=192,
	 parameter S = 192
	 
)
(
    input  logic[E1-1:0] A, 
	 input  logic[E2-1:0]B,
    input  logic sel,
    output logic[S-1:0] C
);
    always_comb begin
        case(sel)
            1'b0: C = A;		
            1'b1: C = B;
            default: C = B; // undefined
        endcase
    end
endmodule : mux_2to1