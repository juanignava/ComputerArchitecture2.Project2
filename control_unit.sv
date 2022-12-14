 module control_unit
(
    input  logic[1:0] instruction_type, func,
    input  logic      rst, imm, vector,
    output logic      JumpI, JumpCI, JumpCD, MemToReg, MemWrite, ImmSrc, VectorOp,
                      ALUSrc1, ALUSrc2, RegVWrite, RegSWrite,
    output logic[1:0] ALUOp, ALUSrc3
);
            
    always_latch begin
        if (rst) begin
            JumpI = 0;
            JumpCI = 0;
            JumpCD = 0;
            MemToReg = 0;
            MemWrite = 0;
            ALUOp = 0;
            ALUSrc1 = 0;
            ALUSrc2 = 0;
            ALUSrc3 = 0;
            ImmSrc = 0;
            VectorOp = 0;
            RegVWrite = 0;
            RegSWrite = 0;
        end

        // Instrucciones de control
        if (instruction_type == 2'b00) begin
            MemToReg = 0;
            MemWrite = 0;
            VectorOp = 1'b0;
            RegVWrite = 0;
            RegSWrite = 0;
            ALUSrc1 = 1'b0;
				ALUSrc2 = 1'b0;
                
            // Salto con condicion igual
            if (func == 2'b00 && imm == 1'b0) begin
                JumpCI = 1;
                JumpCD = 0;
                JumpI = 0;
                ImmSrc = 1; 
                ALUSrc3 = 2'b11;
					 ALUOp = 2'b01;
                
            end

            // Salto incondicional
            if (func == 2'b00 && imm == 1'b1) begin
                JumpCI = 0;
                JumpCD = 0;
                JumpI = 1;
                ImmSrc = 0;
                ALUSrc3 = 2'b00;
					 ALUOp = 2'b00;
            end

            // Salto con condicion desigual
            if (func == 2'b01 && imm == 1'b0) begin
                JumpCI = 0;
                JumpCD = 1;
                JumpI = 0;
                ImmSrc = 1;
                ALUSrc3 = 2'b11;
					 ALUOp = 2'b01;
            end 
        end
        
        // Instrucciones de memoria escalares
        if (instruction_type == 2'b01 && vector == 1'b0) begin
            ImmSrc = 1'b1;
            ALUSrc3 = 2'b10;
            ALUSrc2 = 1'b0;
            RegVWrite = 1'b0;
            ALUSrc1 = 1'b0;
            VectorOp = 1'b0;
            JumpCI = 0;
            JumpCD = 0;
            JumpI = 0;
            ALUOp = 2'b00;

            if (func == 2'b00) begin
                RegSWrite = 1'b0;
                MemWrite = 1'b1;
                MemToReg = 1'b0;
            end
                    
            if (func == 2'b01) begin
                RegSWrite = 1'b1;
                MemWrite = 1'b0;
                MemToReg = 1'b1;
            end
        end
        
        // Instrucciones de memoria vectoriales
        if (instruction_type == 2'b01 && vector == 1'b1) begin
            ImmSrc = 1'b1;
            ALUSrc3 = 2'b10;
				ALUSrc2 = 1'b0;
            RegSWrite = 1'b0;
            VectorOp = 1'b1;
            JumpCI = 0;
            JumpCD = 0;
            JumpI = 0;
				ALUOp = 2'b10;

            if (func == 2'b00) begin
                RegVWrite = 1'b0;
                MemWrite = 1'b1;
                MemToReg = 1'b0;
					 ALUSrc1 = 1'b1;
            end
                    
            if (func == 2'b01) begin
                RegVWrite = 1'b1;
                MemWrite = 1'b0;
                MemToReg = 1'b1;
					 ALUSrc1 = 1'b0;
            end
        end
        
        // Instrucciones de datos sin inmediato
        if (instruction_type == 2'b10 && imm == 1'b0) begin
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            JumpCI = 0;
            JumpCD = 0;
            JumpI = 0;
            ImmSrc = 1'b0;
				ALUSrc3 = 2'b01;
				ALUSrc1 = 1'b0;
            
            if (func == 2'b00 && vector == 1'b0) begin
                ALUSrc2 = 1'b0;
                ALUOp = 2'b00;
                RegSWrite = 1'b1;
                RegVWrite = 1'b0;
                VectorOp = 1'b0;
            end
            if (func == 2'b01 && vector == 1'b0) begin
                ALUSrc2 = 1'b0;
                ALUOp = 2'b01;
                RegSWrite = 1'b1;
                RegVWrite = 1'b0;
                VectorOp = 1'b0;
            end
            if (func == 2'b00 && vector == 1'b1) begin
                ALUSrc2 = 1'b1;
					 ALUOp = 2'b00;
                RegSWrite = 1'b0;
                RegVWrite = 1'b1;
                VectorOp = 1'b1;
            end
            if (func == 2'b01 && vector == 1'b1) begin
                ALUSrc2 = 1'b1;
					 ALUOp = 2'b01;
                RegSWrite = 1'b0;
                RegVWrite = 1'b1;
                VectorOp = 1'b1;
            end
            if(func == 2'b10 && vector == 1'b1) begin
                ALUSrc2 = 1'b1;
					 ALUOp = 2'b10;
                RegSWrite = 1'b0;
                RegVWrite = 1'b1;
                VectorOp = 1'b1;
					 
            end
        end

        // Instrucciones de datos con inmediato
        if (instruction_type == 2'b10 && imm == 1'b1) begin
            ALUSrc2 = 1'b0;
            ALUSrc3 = 2'b10;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            JumpCI = 0;
            JumpCD = 0;
            JumpI = 0;
            VectorOp = 0;
            ALUSrc1 = 1'b0;
            RegSWrite = 1'b1;
            RegVWrite = 1'b0;
            ImmSrc = 1'b1;

            if (func == 2'b00) begin
                ALUOp = 2'b00;
            end
            if (func == 2'b01) begin
                ALUOp = 2'b01;
            end
            if (func == 2'b10) begin
                ALUOp = 2'b10;
            end
            if (func == 2'b11) begin
                ALUOp = 2'b11;
            end
        end
    end
endmodule : control_unit
