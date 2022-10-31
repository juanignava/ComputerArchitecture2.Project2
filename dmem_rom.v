module dmem_rom
#(
    parameter S=32,
    parameter V=192,
    parameter SIZE=30000
)
(
    input logic isVector,
    input  logic[S-1:0] address,
    output logic[S-1:0] rd
);
    logic [S-1:0] dmem_ROM[0:SIZE-1];
    logic[S-1:0] rdTemp0, rdTemp1, rdTemp2, rdTemp3, rdTemp4, rdTemp5;
    
    initial begin
       $readmemh("imageData.txt", dmem_ROM);
    end

    always begin
        if (isVector == 1) begin
            rdTemp0 = dmem_ROM[address[S-1:0]];
            //rdTemp1 = dmem_ROM[address+1];
            //rdTemp2 = dmem_ROM[address+2];
            //rdTemp3 = dmem_ROM[address+3];
            //rdTemp4 = dmem_ROM[address+4];
            //rdTemp5 = dmem_ROM[address+5];
        end
        else begin
            rdTemp0 = 2;
            //rdTemp1 = 32'd0;
            //rdTemp2 = 32'd0;
            //rdTemp3 = 32'd0;
            //rdTemp4 = 32'd0;
            //rdTemp5 = 32'd0;
        end
    end

    assign rd = rdTemp0;//{rdTemp5, rdTemp4, rdTemp3, rdTemp2, rdTemp1, rdTemp0};
endmodule
