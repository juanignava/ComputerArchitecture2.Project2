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
	logic [N-1:0] pc;
	logic [N-1:0] pc_temp;
	
	always_ff @(posedge clk) begin
	
		pc_temp <= pc;
			
	end
	
	always_ff @(posedge clk, negedge clr) begin
	
		if (clr == 0)
		
			pc <= 0;
			
		else if (load == 1)
		
			pc <= pc_in;
			
		else
		
			pc <= pc;
	
	end
	
	assign pc_out = pc;
	
endmodule
