 module segment_ex_mem (input logic clk, rst,
								input logic MemToReg_in,
								input logic MemRead_in,
								input logic MemWrite_in,
								input logic VectorOp_in,
								input logic [191:0] alu_in,
								input logic [191:0] mux1_in,
								input logic [3:0] RR_in,															
								output logic MemToReg_out,
								output logic MemRead_out,
								output logic MemWrite_out,
								output logic VectorOp_out,								
								output logic [191:0] alu_out,
								output logic [191:0] mux1_out,
								output logic [3:0] RR_out);
			
	always_ff@(negedge clk, posedge rst)
	
		if(rst)
		
			begin
			
				MemToReg_out = 0;
				MemRead_out = 0;
				MemWrite_out = 0;
				VectorOp_out = 0;
				alu_out = 0;
				mux1_out = 0;
				RR_out = 0;
				
			end
			
		else 
		
			begin
			
				MemToReg_out = MemToReg_in;
				MemRead_out = MemRead_in;
				MemWrite_out = MemWrite_in;
				VectorOp_out = VectorOp_in;
				alu_out = alu_in;
				mux1_out = mux1_in;
				RR_out = RR_in;
				
			end
		
endmodule
