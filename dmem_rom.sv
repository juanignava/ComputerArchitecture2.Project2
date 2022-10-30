module dmem_rom
#(
    parameter S=32,
    parameter SIZE=150000
)
(
    input  logic[S-1:0] address,
    output logic[S-1:0] rd
);
    logic [S-1:0] dmem_ROM[0:SIZE-1];
    
    initial begin
       $readmemh("C:\Users\Jose David\Documents\GitKraken\Arqui2\ComputerArchitecture2.Project2\TextFiles\imageData.txt", dmem_ROM);
    end

    assign rd = dmem_ROM[address];
endmodule : dmem_rom
