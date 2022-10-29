module adder
#(
    parameter N=32
)
(
    input  logic[N-1:0] A,
    input  logic[N-1:0] B,
    output logic[N-1:0] C
);
    assign C = A + B;
endmodule : adder
