`timescale 1 ps / 1 ps
module dmem_rom_tb ();

    logic isVector;
    logic [31:0] address;
    logic [191:0] rd;

    dmem_rom dmem_rom(
        .isVector(isVector),
        .address(address),
        .rd(rd)
    );

    initial begin
    
        isVector = 0;
        address = 0;

        #10

        isVector = 1;
        address = 2;

        #10
        isVector = 0;
        address = 1;
		  

    end

endmodule