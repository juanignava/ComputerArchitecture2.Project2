module memoryController
#(
    parameter S=32,
    parameter V=192,
    parameter SIZE_INS=1000,
    parameter SIZE_ROM=30000,
    parameter SIZE_RAM=30000,
    parameter SIZE_REG=15
)
(
    input  logic        clk,
    input  logic        we,
    input  logic        VecOp,
    input  logic        switchStart,
    input  logic[S-1:0] pc,
    input  logic[S-1:0] address,
    input  logic[V-1:0] wd,
    input  logic[SIZE_REG*S-1:0] switch_regs,
    output logic[S-1:0] instruction,
    output logic[V-1:0] rd
);
    localparam INS_START = 0;
    localparam INS_END = SIZE_INS - 1;
    localparam ROM_START = INS_END + 1;
    localparam ROM_END = ROM_START + SIZE_ROM - 1;
    localparam RAM_START = ROM_END + 1;
    localparam RAM_END = RAM_START + SIZE_RAM - 1;
    localparam REG_START = RAM_END + SIZE_REG * S - 1;

    logic[V-1:0] romData, ramData, regData;
    logic[V-1:0] wd_mem_ctrl;
    logic[S-1:0] address_mem_ctrl;
    logic[S-1:0] address_ram, addres_rom;
    logic[2:0]   wait_cycles = 3'b0;
    logic        we_mem_ctrl = 1'b0;
    logic        has_to_write = 1'b0;
    logic[S-1:0] regs[SIZE_REG-1:0];

    assign regs[0] = switch_regs[31:0];
    assign regs[1] = switch_regs[63:32];
    assign regs[2] = switch_regs[95:64];
    assign regs[3] = switch_regs[127:96];
    assign regs[4] = switch_regs[159:128];

    // 32-bits scalar, 10 instructions
    imem #(S, SIZE_INS) imem_rom(
        .pc(pc),
        .instruction(instruction)
    );

    // 32-bits scalar, 150 000 address
    dmem_rom #(S, SIZE_ROM) rom(
        .address(address - ROM_START + wait_cycles),
        .rd(romData)
    );

    // 32-bits scalar, 150 000 address
    dmem_ram #(S, SIZE_RAM) ram(
        .switchStart(switchStart),
        .clk(clk),
        .we((we_mem_ctrl | has_to_write)),
        .address(address - RAM_START + wait_cycles),
        .wd(wd),
        .rd(ramData)
    );

    always begin
        we_mem_ctrl <= 1'b0;

        if (clk) begin
            if (wait_cycles != 3'b0) begin
                wait_cycles <= wait_cycles - 3'b1;
            end else begin
                has_to_write <= 1'b0;
            end
        end

        if (we) begin
            if (VecOp == 1'b0) begin
                we_mem_ctrl <= 1'b1;
            end else begin
                wait_cycles <= 3'd6;
                has_to_write <= 1'b1;
            end
        end
    end

    always begin
        // Read regs
        regData <= regs[address - REG_START];
    end

    always begin
        // Reading data from Rom.
        if (address <= ROM_END) begin
            rd = romData;
        end
        // Reading or writing from Ram.
        else if (address <= RAM_END) begin
            rd = ramData;
        end
        // Reading from registers.
        else begin
            rd = regData;
        end
    end
endmodule : memoryController
