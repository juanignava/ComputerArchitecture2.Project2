module imem (input logic [31:0] pc,
				output logic [31:0] instruction);
	
	logic [31:0] imem_ROM[499:0];
	
	initial
	
		// Instructions memory.
		$readmemh("C:/MySpot/ComputerArchitecture2.Project2/TextFiles/instructions.txt", imem_ROM);
		
		
	assign instruction = imem_ROM[pc[31:0]];
	
endmodule 