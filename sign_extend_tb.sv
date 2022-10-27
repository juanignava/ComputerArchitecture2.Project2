module sign_extend_tb ();
	
	logic clk;
	logic [25:0] num_in;
	logic imm_src;
	logic [31:0] num_out;
	
	sign_extend sign_extend_TB (num_in, imm_src, num_out);
	
	initial begin
		
		clk = 0; #2;
		
		// Extend test 1:
		num_in = 26'b01111111111111100001111000; imm_src = 1'b0; #2
		
		// Extend test 2:
		num_in = 26'b01111111111111100001111000; imm_src = 1'b1; #2;

		
	end
	
	always begin
		clk=!clk; #1;
	end
	
endmodule 