module pc_register
#(
    parameter N=32
)
(
    input  logic        clk,
    input  logic        clr,
    input  logic        load,
    input  logic[N-1:0] pc_in,
    output logic[N-1:0] pc_out
);
    logic[N-1:0] pc;

    always_ff @(posedge clk, negedge clr) begin
        if (clr == 0) begin
            pc <= 'b0;
        end else if (load == 1'b1) begin
            pc <= pc_in;
        end else begin
            pc <= pc;
        end
    end

    assign pc_out = pc;
endmodule : pc_register
