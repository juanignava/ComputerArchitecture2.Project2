module VGAControllerTest();

logic clk, hsync, vsync, reset, n_sync, n_blanc, n25MHZCLK;
logic [7:0] R, G, B;

VGA_test VGA_test(.clk(clk),
						.reset(reset),
                  .hsync(hsync),
						.vsync(vsync),
						.n_sync(n_sync),
						.n_blanc(n_blanc),
						.n25MHZCLK(n25MHZCLK),
						.r(R),
						.g(G),
						.b(B));

initial begin
	clk = 0;
	n25MHZCLK = 0;
	reset = 1;
	
	#12 
	
	reset = 0;
end
 
always
begin
	#10 clk = ~clk;
end

endmodule // VGAControllerTest