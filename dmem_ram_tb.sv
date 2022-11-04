`timescale 1 ps / 1 ps
module dmem_ram_tb ();

    logic isVector;
	 logic switchStart;
	 logic clk;
	 logic we;
    logic [31:0] address;
	 logic [191:0] wd;
    logic [191:0] rd;
	 

    dmem_ram dmem_ram(
        .isVector(isVector),
		  .switchStart(switchStart),
		  .clk(clk),
		  .we(we),
        .address(address),
		  .wd(wd),
        .rd(rd)
    );
	 
	 always begin
	
		#1 clk = ~clk; // medio ciclo de reloj equivale a una unidad
		
    end

    initial begin
	 
		  switchStart = 1;
		  clk = 1;
		  
		  #10
		  
		  switchStart = 0;  
		  we = 0;
        isVector = 0;
        address = 0;
		  wd = 0;

        #10

        we = 1;
        isVector = 0;
        address = 0;
		  wd = 33;

        #10
        we = 1;
        isVector = 1;
        address = 2;
		  wd = 64'd123456789112;
		  
		  #10
		  switchStart = 1;
		  

    end

endmodule
