module dmem_ram(input logic switchStart, clk, we,
                input logic [31:0] address, wd,
                output logic [31:0] rd);

    logic [31:0] dmem_RAM[0:149999];
	 
    always @(switchStart)
    $writememh("C:/TextFiles/imageOutput.txt", dmem_RAM);
    // synthesis translate_on

    // Memory meant to be read.
    /*always_ff @(negedge clk)
        begin
            if (address >= 'd0 && address <= 'd129599)
                rd = {31'b0, dmem_RAM[address]};
            else
                begin
                rd = 32'b0;
                //$writememh("C:/MySpot/ComputerArchitecture2.Project2/TextFiles/imageOutput.txt", dmem_RAM);
                end
        end*/

    // Memory meant to be written.
    always_ff @(posedge clk)
        begin
            if (we) 
                begin
                    if (address >= 'd0 && address <= 'd149999)
                        begin
                        dmem_RAM[address] <= wd;
                        //$writememh("C:/MySpot/ComputerArchitecture2.Project2/TextFiles/imageOutput.txt", dmem_RAM);
                        end


                end
        end
    assign rd = {31'b0, dmem_RAM[address]};





endmodule