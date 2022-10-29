module dmem_rom (input logic [31:0] address,
				output logic [31:0] rd);
	
	logic [31:0] dmem_ROM[0:149999];
	
	initial

		//$readmemh("C:/MySpot/ComputerArchitecture2.Project2/TextFiles/imageData.txt", dmem_ROM);
	   $readmemh("C:/TextFiles/imageData.txt", dmem_ROM);	
		
	assign rd = dmem_ROM[address[31:0]];
	
endmodule 