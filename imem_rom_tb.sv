`timescale 1 ps / 1 ps
module imem_rom_tb ();

    logic [31:0] pc;
    logic [31:0] instruction;

    imem imem(
        .pc(pc),
        .instruction(instruction)
    );

    initial begin
    
        pc = 0;

        #10

        pc = 2;

        #10
        pc = 1;
		  

    end

endmodule