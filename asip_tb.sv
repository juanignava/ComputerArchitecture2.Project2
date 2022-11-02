`timescale 1 ps / 1 ps
module asip_tb();

	logic clk;
	logic rst;
	logic [1:0] red_switches;
	logic [1:0] green_switches;
	logic [1:0] blue_switches;
	logic gtype_switch;
	logic switchStart;
	
   logic[23:0] rgb;
   logic v_sync;
   logic h_sync;
   logic vga_clk;
		
	asip procesador_vectorial(clk,
	                          rst,
							 		  red_switches,
									  green_switches,
									  blue_switches,
									  gtype_switch,
									  switchStart,
									  rgb,
									  v_sync,
									  h_sync,
									  vga_clk);
	
	always begin
	
		#1 clk = ~clk; // medio ciclo de reloj equivale a una unidad
		
	end
	
	initial begin
		
		// señales iniciales
		rst = 1;
		clk = 1;
		red_switches =4;
		green_switches = 0;
		blue_switches = 0;
		gtype_switch = 0;
		switchStart = 1;
				
		#10
		
		switchStart = 0;
		rst = 0;
		
		#1000000;
		
		switchStart = 1;
		
	end
		
endmodule