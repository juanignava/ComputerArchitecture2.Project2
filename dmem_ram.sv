module dmem_ram
#(
    parameter S=32,
    parameter SIZE=30
)
(
    input  logic        switchStart,
    input  logic        clk,
    input  logic        we,
    input  logic[S-1:0] address,
    input  logic[S-1:0] wd,
    output logic[S-1:0] rd
);
    logic[S-1:0] dmem_RAM[0:SIZE-1];

    always @(posedge switchStart) begin
        $writememh("C:/MySpot/ComputerArchitecture2.Project2/TextFiles/imageOutput.txt", dmem_RAM);
    end

    // Memory meant to be written.
    always @(negedge clk) begin
        if (we) begin
            dmem_RAM[address] <= wd;
        end
    end

    assign rd = dmem_RAM[address];
endmodule : dmem_ram
