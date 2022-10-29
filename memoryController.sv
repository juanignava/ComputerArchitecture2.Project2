module memoryController
#(
    parameter S=32,
    parameter V=192
)
(
    input  logic        clk,
    input  logic        we,
    input  logic        VecOp,
    input  logic        switchStart,
    input  logic[S-1:0] pc,
    input  logic[V-1:0] address,
    input  logic[V-1:0] wd,
    output logic[S-1:0] instruction,
    output logic[V-1:0] rd
);
    logic[S-1:0] mapAddressInstructions, instructionData;
    logic[V-1:0] romData, ramData, mapAddressROM, mapAddressRAM;

    // 32-bits scalar, 192-bits vec, 150 000 address
    dmem_ram #(S, V, 30000) ram(
        .switchStart(switchStart),
        .clk(clk),
        .we(we),
        .VecOp(VecOp),
        .address(mapAddressRAM),
        .wd(wd),
        .rd(ramData)
    );

    // 192-bits vec, 150 000 address
    dmem_rom #(V, 30000) rom(
        .VecOp(VecOp),
        .address(mapAddressROM),
        .rd(romData)
    );

    // 32-bits scalar, 10 instructions
    imem #(S, 10) imem_rom(
        .pc(mapAddressInstructions),
        .instruction(instructionData)
    );

    always begin
            // Reading instructions.
            /*if (pc >= 'd0 && pc < 'd1000)
                begin
                    mapAddressInstructions = pc;
                    instruction = instructionData;
                end
        
            // Reading data from Rom.
            if (address >= 'd1000 && address < 'd151000)
                begin
                    mapAddressROM = address - 'd1000;
                    rd = romData;
                end
            
            // Reading or writing from Ram.
            else if (address >= 'd151000 && address < 'd301000)
                begin
                    mapAddressRAM = address - 'd151000;
                    rd = ramData;
                end
                
            // Case if nothing happens.
            else
                begin
                    mapAddressRAM = 192'b0;
                    mapAddressROM = 192'b0;
                    rd = 192'b0;
                end*/
    end
endmodule : memoryController
