module VGA_test(input  logic clk, reset,
							output logic hsync, vsync, n_sync, n_blanc, n25MHZCLK,
							output logic [7:0] r,g,b);
	
	logic [9:0] x, y;
	logic [31:0] address, prev_address;
	logic [191:0] data;
	logic [7:0] r_siguiente,g_siguiente,b_siguiente;
	// Satus de la salida de video al monitor
	logic video_on;

	// se instansea HV_sync
	HV_sync 		vga_sync_unit 		(.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .enable(video_on), .clk_out(n25MHZCLK), .x(x), .y(y));
	
	dmem_rom dmem_rom0(.isVector(1'd1), .address(address), .rd(data));
	
	
	
	always_ff @(posedge n25MHZCLK)
		begin
			// calculate the address
			if (y < 100 && x < 100) begin
				address = y * 300 + x*3;
				prev_address = address; 
			end
			else begin
				address = prev_address;
			end
				
			r_siguiente = data[7:0];
			g_siguiente = data[39:32];
			b_siguiente = data[71:64];
				
		end
	
	
	assign r = (video_on) ? r_siguiente : 8'b0;
	assign g = (video_on) ? g_siguiente : 8'b0;
	assign b = (video_on) ? b_siguiente : 8'b0;
	assign n_sync  =  1'b0;
	assign n_blanc =  1'b1;
		  
endmodule