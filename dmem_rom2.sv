module dmem_rom2
#(
    parameter S=32,
	 parameter V=192,
    parameter SIZE=30015
)
(
    input  logic[S-1:0] address,
    output logic[V-1:0] rd
);
    logic [S-1:0] dmem_ROM[0:SIZE-1];
    
    initial
	 // Directorio Nacho N
       //$readmemb("C:/Users/juan navarro/Documents/Implementaciones Arqui 2/ComputerArchitecture2.Project2/imageOutput.txt", dmem_ROM);
		 $readmemb("imageOutput.txt", dmem_ROM);

		 // Directorio Moni
       //$readmemb("C:/MySpot/ComputerArchitecture2.Project2/imageOutput.txt", dmem_ROM);

    //assign rd = {{5*S{1'd0}}, dmem_ROM[address[S-1:0]]};
	 assign rd = {dmem_ROM[address[S-1:0]+5], dmem_ROM[address[S-1:0]+4], dmem_ROM[address[S-1:0]+3], dmem_ROM[address[S-1:0]+2], dmem_ROM[address[S-1:0]+1], dmem_ROM[address[S-1:0]]};
endmodule
