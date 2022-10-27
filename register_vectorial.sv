module register_vectorial(
	input [3:0] RS1,
	input [3:0] RS2,
	input [3:0] RS3,
	input [3:0] RD,
	input [191:0] WD,
	input wr_enable,
	input clk,
	input rst,
	
	output [191:0] RD1,
	output [191:0] RD2,
	output [191:0] RD3
	);
	
	logic [191:0] R0, R1, R2, R3, R4, R5, R6, R7;

	logic [191:0] RD1_temp, RD2_temp, RD3_temp;
	
	//always_ff @(posedge clk) begin
	always @(*) begin
		
		case (RS1)
		
			// resgistro RS1 que se lee
			4'd0: RD1_temp = R0;	// registro 0
			4'd1: RD1_temp = R1; 	// registro 1
			4'd2: RD1_temp = R2; 	// registro 2
			4'd3: RD1_temp = R3; 	// registro 3
			4'd4: RD1_temp = R4; 	// registro 4
			4'd5: RD1_temp = R5; 	// registro 5
			4'd6: RD1_temp = R6; 	// registro 6
			4'd7: RD1_temp = R7; 	// registro 7
			default: RD1_temp = 0;
		
		endcase
		
		
		case (RS2)
		
			// registro RS2 que se lee
			4'd0: RD2_temp = R0; // registro 0
			4'd1: RD2_temp = R1; // registro 1
			4'd2: RD2_temp = R2; // registro 2
			4'd3: RD2_temp = R3; // registro 3
			4'd4: RD2_temp = R4; // registro 4
			4'd5: RD2_temp = R5; // registro 5
			4'd6: RD2_temp = R6; // registro 6
			4'd7: RD2_temp = R7; // registro 7
			default: RD2_temp = 0;
		
		endcase
		
		
		case (RS3)
		
			// registro RS3 que se lee
			4'd0: RD3_temp = R0; // registro 0
			4'd1: RD3_temp = R1; // registro 1
			4'd2: RD3_temp = R2; // registro 2
			4'd3: RD3_temp = R3; // registro 3
			4'd4: RD3_temp = R4; // registro 4
			4'd5: RD3_temp = R5; // registro 5
			4'd6: RD3_temp = R6; // registro 6
			4'd7: RD3_temp = R7; // registro 7
			default: RD3_temp = 0;
		
		endcase
		
	end
	
	always_ff @(posedge clk or posedge rst) begin
	
		if(rst)
		begin
			R0 = 192'd0;
			R1 = 192'd0;
			R2 = 192'd0;
			R3 = 192'd0;
			R4 = 192'd0;
			R5 = 192'd0;
			R6 = 192'd0;
			R7 = 192'd0;
		
		end
	
		else if (wr_enable)
		begin
		
			case (RD)
			
				// escribe en el registro A3
				4'd0: R0 = WD; // registro 0
				4'd1: R1 = WD; // registro 1
				4'd2: R2 = WD; // registro 2
				4'd3: R3 = WD; // registro 3
				4'd4: R4 = WD; // registro 4
				4'd5: R5 = WD; // registro 5
				4'd6: R6 = WD; // registro 6
				4'd7: R7 = WD; // registro 7
			
			endcase
		
		end
		
		
		
	end
		
		
	// logica de salidas
	assign RD1 = RD1_temp;
	assign RD2 = RD2_temp;
	assign RD3 = RD3_temp;

	
endmodule
