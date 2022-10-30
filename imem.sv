module imem
#(
    // Number of bits
    parameter N=32,
    // Number of instructions
    parameter INS=10
)
(
    input  logic[N-1:0] pc,
    output logic[N-1:0] instruction
);    
    logic [N-1:0] imem_ROM[INS-1:0];

    initial begin
        // Instructions memory
        $readmemb("C:/MySpot/ComputerArchitecture2.Project2/TextFiles/instructions.txt", imem_ROM);
    end

    assign instruction = imem_ROM[pc[N-1:0]];
endmodule : imem
