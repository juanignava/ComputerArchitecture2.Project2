module imem
#(
	parameter N=32,
	parameter INS = 1000
)
(
	input logic[N-1:0] pc,
	output logic[N-1:0] instruction
);

	logic [N-1:0] imem_ROM[INS-1:0];
	
	initial
	// Directorio Nacho N
       $readmemb("C:/Users/juan navarro/Documents/Implementaciones Arqui 2/ComputerArchitecture2.Project2/instructions.txt", imem_ROM);
		 
		 // Directorio Moni
       //$readmemb("C:/MySpot/ComputerArchitecture2.Project2/instructions.txt", imem_ROM);
	
	assign instruction = imem_ROM[pc[N-1:0]];
	
endmodule