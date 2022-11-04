module register_vectorial_tb ();

	// Test bench del modulo register_file
	
	logic [3:0] RS1, RS2, RS3, RD;
	logic [191:0] WD, RD1, RD2, RD3;
	logic wr_enable, clk, rst;
	
	register_vectorial register_vectorial(RS1, RS2, RS3, RD, WD, wr_enable, clk, rst, 
										RD1, RD2, RD3);
	
	
	always begin
	
		#10 clk = ~ clk; // Un ciclo de reloj equivale a 10 unidades de tiempo
	
	end
	
	initial begin
	
		clk = 0;
		rst = 1;
		RS1 = 4'd0;
		RS2 = 4'd0;
		RS3 = 4'd0;
		WD = 31'd0;
		wr_enable = 0;
		
		#20
		
		// escribir en el registro 7 un 99
		
		rst = 0;
		wr_enable = 1;
		RD = 4'd7;
		WD = 192'b111111111100000000001111111111001111111111000000000011111111110011111111110000000000111111111100111111111100000000001111111111001111111111000000000011111111110011111111110000000000111111111100;
		
		#20
		
		// escribir en el resgitro 4 un 50 con wr_enable en 0 (no debe escribir)
		
		wr_enable = 0;
		RD = 4'd4;
		WD = 192'b000001111111111000001111111111010000011111111110000011111111110100000111111111100000111111111101000001111111111000001111111111010000011111111110000011111111110100000111111111100000111111111101;
		
		#20
		
		// escribir en el resgitro 0 un 255
		
		wr_enable = 1;
		RD = 4'd0;
		WD = 192'b000001111111111000001111111111010000011111111110000011111111110100000111111111100000111111111101000001111111111000001111111111010000011111111110000011111111110100000111111111100000111111111101;
		
		#20
		
		// leer del registro 7 y 0 el valor que tienen
		
		wr_enable = 0;
		RS1 = 4'd7;
		RS2 = 4'd0;
		
	
		#20
		rst = 0;
		wr_enable = 1;
		RD = 4'd7;
		WD = 192'b101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101011;
		
		#20
		wr_enable = 0;
		RS1 = 4'd7;
		
		
		
	
	end

endmodule 