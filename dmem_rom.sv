module dmem_rom
#(
    parameter S=32,
    parameter V=192,
    parameter SIZE=30000
)
(
    input logic isVector,
    input  logic[S-1:0] address,
    output logic[V-1:0] rd
);
    logic [S-1:0] dmem_ROM[0:SIZE-1];
    logic[S-1:0] rdTemp0, rdTemp1, rdTemp2, rdTemp3, rdTemp4, rdTemp5;
    
    initial
       //$readmemb("C:/Users/juan navarro/Documents/Implementaciones Arqui 2/ComputerArchitecture2.Project2/imageData.txt", dmem_ROM);
		 $readmemb("imageData.txt", dmem_ROM, 0, SIZE-1);

    always_comb begin
        if (isVector == 1) begin
            rdTemp0 = dmem_ROM[address[S-1:0]];
            rdTemp1 = dmem_ROM[address[S-1:0]+1];
            rdTemp2 = dmem_ROM[address[S-1:0]+2];
            rdTemp3 = dmem_ROM[address[S-1:0]+3];
            rdTemp4 = dmem_ROM[address[S-1:0]+4];
            rdTemp5 = dmem_ROM[address[S-1:0]+5];
        end
        else begin
            rdTemp0 = dmem_ROM[address[S-1:0]];
            rdTemp1 = 0;
            rdTemp2 = 0;
            rdTemp3 = 0;
            rdTemp4 = 0;
            rdTemp5 = 0;
        end
    end

    assign rd = {rdTemp5, rdTemp4, rdTemp3, rdTemp2, rdTemp1, rdTemp0};
endmodule
