module dmem_ram
#(
    parameter S=32,
    parameter V=192,
    parameter SIZE=14
)
(
    input  logic        switchStart,
    input  logic        clk,
    input  logic        we,
    input  logic        VecOp,
    input  logic[S-1:0] address,
    output logic[V-1:0] wd,
    output logic[V-1:0] rd
);
    logic[S-1:0] dmem_RAM[0:SIZE-1];
    logic[V-1:0] tmp_read;
     
    always @(posedge switchStart)
        $writememh("C:\Users\Jose David\Documents\GitKraken\Arqui2\ComputerArchitecture2.Project2\TextFiles\imageOutput.txt", dmem_RAM);

    // Memory meant to be written.
    always_ff @(*) begin
        if (clk == 1'b0) begin
            if (we) begin
                //if (address >= 'd0 && address < 'd150000) begin
                if (VecOp == 1'b0) begin
                    dmem_RAM[address] <= wd[31:0];
                end else begin
                    dmem_RAM[address] <= wd[31:0];
                    dmem_RAM[address + 1] <= wd[63:32];
                    dmem_RAM[address + 2] <= wd[95:64];
                    dmem_RAM[address + 3] <= wd[127:96];
                    dmem_RAM[address + 4] <= wd[159:128];
                    dmem_RAM[address + 5] <= wd[191:160];
                end
            end
        end else begin
            if (VecOp == 1'b0) begin
                tmp_read <= {160'b0, dmem_RAM[address]};
            end else begin
                tmp_read <= {dmem_RAM[address + 5], dmem_RAM[address + 4], dmem_RAM[address + 3], dmem_RAM[address + 2], dmem_RAM[address + 1], dmem_RAM[address]};
            end
        end
    end

    assign rd = tmp_read;
endmodule : dmem_ram
