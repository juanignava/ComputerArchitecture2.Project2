module mux_4to1_tb ();
	
	logic clk;
	logic [31:0] A, B, C;
	logic [191:0] D;
	logic [1:0] sel;
	logic [191:0] E;
	
	mux_4to1 mux_4to1_TB (A, B, C, D, sel, E);
	
	initial begin
		
		clk = 0; #2;
		
		// Mux 4 to 1, test 1:
		A = 32'b10000000000000000000000000000000; 
		B = 32'b10000000000000000000000000000001; 
		C = 32'b10000000000000000000000000000010; 
		D = 192'b101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011;
		sel = 2'b00; #2
		
		// Mux 4 to 1, test 1:
		A = 32'b10000000000000000000000000000000; 
		B = 32'b10000000000000000000000000000001; 
		C = 32'b10000000000000000000000000000010; 
		D = 192'b101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011;
		sel = 2'b01; #2
		
		// Mux 4 to 1, test 1:
		A = 32'b10000000000000000000000000000000; 
		B = 32'b10000000000000000000000000000001; 
		C = 32'b10000000000000000000000000000010; 
		D = 192'b101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011;
		sel = 2'b10; #2
		
		// Mux 4 to 1, test 1:
		A = 32'b10000000000000000000000000000000; 
		B = 32'b10000000000000000000000000000001; 
		C = 32'b10000000000000000000000000000010; 
		D = 192'b101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011101111000111111000001111000000111011110001111110000011110000001110111100011111100000111100000011;
		sel = 2'b11; #2;
		
	end
	
	always begin
		clk=!clk; #1;
	end
	
endmodule