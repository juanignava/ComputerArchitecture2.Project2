module memoryController_tb();

	logic 			clk;
	logic 			rst;
	logic				we;
	logic				VecOp;
	logic				switchStart;
	logic[31:0]	pc;
	logic[31:0]	address;
	logic[191:0]	wd;
	logic[31:0]	instruction;
	logic[191:0]	rd;
	
	memoryController memoryController(
		.clk(clk),
		.rst(rst),
		.we(we),
		.VecOp(VecOp),
		.switchStart(switchStart),
		.pc(pc),
		.address(address),
		.wd(wd),
		.instruction(instruction),
		.rd(rd)
	);
	
	always begin
	
		#1 clk = ~clk; // medio ciclo de reloj equivale a una unidad
		
   end
	
	initial begin
	
		clk = 1;
		rst = 0;
		switchStart = 1;
		
		#10
		
		// se espera que se lea la dirección 3 de las instrucciones
		switchStart = 0;
		we = 0;
		VecOp = 0;
		pc = 3;
		address = 2;
		wd = 20;
		
		#10
		
		// se espera leer la dirección 4 de las instrucciones, la 0 de la rom
		we = 0;
		VecOp = 0;
		pc = 4;
		address = 1000;
		wd = 1; 
		
		#10
		
		// se espera leer la dirección 4 de las instrucciones, la 0 de la ram y que además se escriba en la dirección 0 de la ram un 1
		we = 1;
		VecOp = 0;
		pc = 4;
		address = 31000;
		wd = 3;
		
		#10 
		
		we = 0;
		 
		#10
		
		// se espera leer la dirección 4 de las instrucciones, la 0 de la ram y que además se escriba un numero grande de forma vectorial en la ram
		we = 1;
		VecOp = 1;
		pc = 4;
		address = 31005; 
		wd = 64'd1234567891123;
		
		#10
		switchStart = 1;
		
		// se espera leer la dirección 4 de las instrucciones, la 0 de la ram y que además se escriba un numero grande de forma vectorial en la ram
		we = 0;
 
		
	
	end

endmodule


	