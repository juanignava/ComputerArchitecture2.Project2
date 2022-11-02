module memoryController
#(
	parameter S = 32,
	parameter V = 192,
	parameter SIZE_INS = 1000,
	parameter SIZE_ROM = 30000,
	parameter SIZE_RAM = 30030
)
(
	input logic 			clk,
	input logic 			rst,
	input logic				we,
	input logic				VecOp,
	input logic				switchStart,
	input logic[S-1:0]	pc,
	input logic[S-1:0]	address,
	input logic[V-1:0]	wd,
	output logic[S-1:0]	instruction,
	output logic[V-1:0]	rd,
	
	input logic[1:0]   red_switches, green_switches, blue_switches, tran_switches,
	 
   input logic        gtype_switch
);

	logic [S-1:0] address_ins, address_rom, address_ram, instructionData;
	logic [V-1:0] romData, ramData, ramData2;

	// instruction memory
	imem #(S, SIZE_INS) imem(
		.pc(address_ins),
		.instruction(instructionData)
	);
	
	// rom memory
	dmem_rom #(S, V, SIZE_ROM) dmem_rom1(
		.isVector(VecOp),
		.address(address_rom), 
		.rd(romData)
	);
	
	// ram memory (write only)
	dmem_ram #(S, V, SIZE_RAM) dmem_ram(
		.isVector(VecOp),
		.switchStart(switchStart),
		.clk(clk),
		.we(we),
		.address(address_ram),
		.wd(wd),
		.rd(ramData),
		.red_switches(red_switches),
		.green_switches(green_switches),
		.blue_switches(blue_switches),
		.tran_switches(tran_switches),
		.gtype_switch(gtype_switch)
	); 
	
	// ram memory (read only)
	dmem_rom2 #(S, V, SIZE_RAM) dmem_rom2(
		.address(address_ram),
		.rd(ramData2)
	);
	
	// Asign value logic
	always_latch
		begin
			
			// reading instructions
			if (pc >= 'd0 && pc < 'd1000)
			begin
				address_ins = pc;
				instruction = instructionData;
			end
			
			// reading data from rom 1
			if (address >= 'd1000 && address < 'd31000)
			begin
				address_rom = address - 'd1000;
				rd = romData;
			end
			
			// writing and data data on ram
			else if (address >= 'd31000 && address < 'd61015)
			begin
				address_ram = address - 'd31000;
				rd = ramData;
			end
			
			// if addres is different
			else
			begin
				address_rom = 'd0;
				address_ram = 'd0;
				rd = 'd0;
			end
			
		end
	

endmodule
