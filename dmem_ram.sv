module dmem_ram
#(
    parameter S=32,
	 parameter V=192,
    parameter SIZE=30015
)
(
	 input  logic			isVector,
    input  logic        switchStart,
    input  logic        clk,
    input  logic        we,
    input  logic[S-1:0] address,
    input  logic[V-1:0] wd,
    output logic[V-1:0] rd,
	 
	 input logic[1:0]   red_switches, green_switches, blue_switches, tran_switches,
	 
    input logic        gtype_switch
);
    logic[S-1:0] dmem_RAM[0:SIZE-1] = '{SIZE{32'd0}};
	 //logic[S-1:0] rdTemp0, rdTemp1, rdTemp2, rdTemp3, rdTemp4, rdTemp5;
	 
	  

    always @(posedge switchStart)
		// Directorio Nacho N
      $writememb("C:/Users/juan navarro/Documents/Implementaciones Arqui 2/ComputerArchitecture2.Project2/imageOutput.txt", dmem_RAM);
		//$writememb("imageOutput.txt", dmem_RAM);
		
		// Directorio Moni
			//$writememb("C:/MySpot/ComputerArchitecture2.Project2/imageOutput.txt", dmem_RAM);
	
    /*	
	 always_comb begin
        if (isVector == 1) begin
            rdTemp0 = dmem_RAM[address[S-1:0]];
            rdTemp1 = dmem_RAM[address[S-1:0]+1];
            rdTemp2 = dmem_RAM[address[S-1:0]+2];
            rdTemp3 = dmem_RAM[address[S-1:0]+3]; 
            rdTemp4 = dmem_RAM[address[S-1:0]+4];
            rdTemp5 = dmem_RAM[address[S-1:0]+5];
        end
        else begin
            rdTemp0 = dmem_RAM[address[S-1:0]];
            rdTemp1 = 0;
            rdTemp2 = 0;
            rdTemp3 = 0;
            rdTemp4 = 0;
            rdTemp5 = 0;
        end
    end
	 */


    // Memory meant to be written.
    always_ff @(negedge clk) begin
        if (we) begin
				if (isVector == 1) begin
					dmem_RAM[address] <= wd[S-1:0];
					dmem_RAM[address+1] <= wd[2*S-1:S];
					dmem_RAM[address+2] <= wd[3*S-1:2*S];
					dmem_RAM[address+3] <= wd[4*S-1:3*S];
					dmem_RAM[address+4] <= wd[5*S-1:4*S];
					dmem_RAM[address+5] <= wd[6*S-1:5*S];
					
				end
				else begin
					dmem_RAM[address] <= wd[S-1:0];
				end
            
        end
    end
	 
	 // map memory
	 always_ff @(red_switches,  green_switches, blue_switches, tran_switches, gtype_switch) begin
		dmem_RAM[30000] <= red_switches[0];
		dmem_RAM[30001] <= red_switches[1];
		dmem_RAM[30002] <= green_switches[0];
		dmem_RAM[30003] <= green_switches[1];
		dmem_RAM[30004] <= blue_switches[0];
		dmem_RAM[30005] <= blue_switches[1];
		dmem_RAM[30006] <= tran_switches[0];
		dmem_RAM[30007] <= tran_switches[1];
		dmem_RAM[30008] <= gtype_switch;
	 end

    assign rd = 0;//{dmem_RAM[address[S-1:0]+5], dmem_RAM[address[S-1:0]+4], dmem_RAM[address[S-1:0]+3], dmem_RAM[address[S-1:0]+2], dmem_RAM[address[S-1:0]+1], dmem_RAM[address[S-1:0]]};//{{V-S{1'd0}}, dmem_RAM[address[S-1:0]]};//{rdTemp5, rdTemp4, rdTemp3, rdTemp2, rdTemp1, rdTemp0};
endmodule : dmem_ram