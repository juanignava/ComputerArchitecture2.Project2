`timescale 1 ps / 1 ps
module dmem_rom2_tb ();

    logic [31:0] address;
    logic [191:0] rd;

    dmem_rom2 dmem_rom2(
        .address(address),
        .rd(rd)
    );

    initial begin
    
        address = 0;

        #10

        address = 2;

        #10
        address = 1;
		  

    end

endmodule