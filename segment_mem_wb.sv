 module segment_mem_wb (input logic clk, rst,
								input logic MemToReg_in,
								input logic [191:0] mem_in,
								input logic [191:0] alu_in,
								input logic [3:0] RR_in,								
								output logic MemToReg_out,
								output logic [191:0] mem_out,
								output logic [191:0] alu_out,
								output logic [3:0] RR_out);
			
	always_ff@(negedge clk, posedge rst)
	
		if(rst)
		
			begin
			
				MemToReg_out = 0;
				mem_out = 0;
				alu_out = 0;
				RR_out = 0;
				
			end
			
		else 
		
			begin
			
				MemToReg_out = MemToReg_in;
				mem_out = mem_in;
				alu_out = alu_in;
				RR_out = RR_in;
				
			end
		
endmodule
