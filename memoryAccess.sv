module memoryAccess
(
    input logic clk, we, VecOp, switchStart,
    input logic [191:0] pc, address, wdv, wds,
    output logic [191:0] rdv, rds, instruction);

    memoryController memoryControllerUnit(clk, memWriteM, VecOp, switchStart, 
                                          pc, address, wdv, wds,
                                          rdv, rds, instruction);

endmodule : memoryAccess
