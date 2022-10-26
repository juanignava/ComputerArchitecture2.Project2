 module segment_id_ex (input logic clk, rst,
							  input logic JumpI_in,
							  input logic JumpCI_in,
							  input logic JumpCD_in,
							  input logic MemToReg_in,
							  input logic MemRead_in,
							  input logic MemWrite_in, 
							  input logic [1:0] ALUOp_in,
							  input logic VectorOp_in,					  
							  input logic ALUSrc1_in,
							  input logic [1:0] ALUSrc2_in,
							  input logic ALUSrc3_in,
							  input logic [191:0] pc_in,
							  input logic [191:0] RSS2_in,
							  input logic [191:0] RSS3_in,
							  input logic [191:0] RSS1_in,							  
							  input logic [191:0] RVS2_in,
							  input logic [191:0] RVS3_in,
							  input logic [191:0] RVS1_in,
							  input logic [3:0] RR_in,
							  input logic [191:0] num_in,							  
							  output logic JumpI_out,
							  output logic JumpCI_out,
							  output logic JumpCD_out,						  
							  output logic MemToReg_out,
							  output logic MemRead_out,
							  output logic MemWrite_out,							  
							  output logic [1:0] ALUOp_out,
							  output logic VectorOp_out,
							  output logic ALUSrc1_out,
							  output logic [1:0] ALUSrc2_out,
							  output logic ALUSrc3_out,
							  output logic [191:0] pc_out,
							  output logic [191:0] RSS2_out,
							  output logic [191:0] RSS3_out,
							  output logic [191:0] RSS1_out,							  
							  output logic [191:0] RVS2_out,
							  output logic [191:0] RVS3_out,
							  output logic [191:0] RVS1_out,
							  output logic [3:0] RR_out,
							  output logic [191:0] num_out);
			
	always_ff@(negedge clk, posedge rst)
	
		if(rst)
		
			begin
			
				JumpI_out = 0;
				JumpCI_out = 0;
				JumpCD_out = 0;
				MemToReg_out = 0;
				MemRead_out = 0;
				MemWrite_out = 0;				
				ALUOp_out = 0;
				VectorOp_out = 0;
				ALUSrc1_out = 0;
				ALUSrc2_out = 0;
				ALUSrc3_out = 0;				
				pc_out = 0;
				RSS2_out = 0;
				RSS3_out = 0;
				RSS1_out = 0;
				RVS2_out = 0;
				RVS3_out = 0;
				RVS1_out = 0;
				RR_out = 0;
				num_out = 0;
				
			end
			
		else 
		
			begin
			
				JumpI_out = JumpI_in;
				JumpCI_out = JumpCI_in;
				JumpCD_out = JumpCD_in;
				MemToReg_out = MemToReg_in;
				MemRead_out = MemRead_in;
				MemWrite_out = MemWrite_in;			
				ALUOp_out = ALUOp_in;
				VectorOp_out = VectorOp_in;
				ALUSrc1_out = ALUSrc1_in;
				ALUSrc2_out = ALUSrc2_in;
				ALUSrc3_out = ALUSrc3_in;				
				pc_out = pc_in;				
				RSS2_out = RSS2_in;
				RSS3_out = RSS3_in;
				RSS1_out = RSS1_in;
				RVS2_out = RVS2_in;
				RVS3_out = RVS3_in;
				RVS1_out = RVS1_in;
				RR_out = RR_in;
				num_out = num_in;
								
			end
		
endmodule
