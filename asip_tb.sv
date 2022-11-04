`timescale 1 ps / 1 ps
module asip_tb();

	logic clk;
	logic rst;
	logic [1:0] red_switches;
	logic [1:0] green_switches;
	logic [1:0] blue_switches;
	logic [1:0] tran_switches;
	logic gtype_switch;
	logic switchStart;
	
   logic[7:0] r, g, b;
   logic vsync, hsync, n_sync, n_blanc, n25MHZCLK;
		
	asip procesador_vectorial(clk,
	                          rst,
							 		  red_switches,
									  green_switches,
									  blue_switches,
									  tran_switches,
									  gtype_switch,
									  switchStart,
									  r, 
									  g, 
									  b,
									  vsync, 
									  hsync, 
									  n_sync, 
									  n_blanc, 
									  n25MHZCLK);
	
	always begin
	
		#1 clk = ~clk; // medio ciclo de reloj equivale a una unidad
		
	end
	
	initial begin
		
		// señales iniciales
		rst = 1;
		clk = 1;
		red_switches =3;
		green_switches = 0;
		blue_switches = 0;
		tran_switches = 1;
		gtype_switch = 0;
		switchStart = 1;
				
		#10
		
		switchStart = 0;
		rst = 0;
		
		#1800000;
		
		switchStart = 1;
		
	end
		
endmodule