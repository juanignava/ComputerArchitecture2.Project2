module alu_6lanes
#(
    parameter V=192,
    parameter S=32
) 
(
    input[V-1:0]  A, B,
    input         op,
    input[1:0]    sel,
    output[V-1:0] C,
    output        flagZ
);
    reg [V-1:0] alu_out_temp = 'd0;

    reg [S-1:0] C0, C1, C2, C3, C4, C5;

    logic flagZ_aux = 1'b0;

    always @(*) begin
        case (op)
            // case operación escalar
            1'b0:			
                case (sel)
                    // case suma
                    2'b00: begin
                        alu_out_temp = A[S-1:0] + B[S-1:0];
                    end
                    // case resta
                    2'b01: begin
                        alu_out_temp = A[S-1:0] - B[S-1:0];
                        flagZ_aux = ~|alu_out_temp;
                    end
                    // case multiplicacion
                    2'b10: begin
                        alu_out_temp = A[S-1:0] * B[S-1:0];
                    end
                    // case división
                    2'b11: begin
                        alu_out_temp = A[S-1:0] / B[S-1:0];
                    end
                    default: begin
                        alu_out_temp = A[S-1:0] + B[S-1:0];
                    end
                endcase
            // case operación vectorial
            1'b1:
                case (sel)
                    // case multiplicación escalar vector
                    2'b00: begin
                        C0 = A[S-1:0] * B[S-1:0];
                        C1 = A[2*S-1:S] * B[S-1:0];
                        C2 = A[3*S-1:2*S] * B[S-1:0];
                        C3 = A[4*S-1:3*S] * B[S-1:0];
                        C4 = A[5*S-1:4*S] * B[S-1:0];
                        C5 = A[6*S-1:5*S] * B[S-1:0];
                        
                        alu_out_temp = {C5, C4, C3, C2, C1, C0};
                    end
                    // case división escalar vector
                    2'b01: begin
                        C0 = A[S-1:0] / B[S-1:0];
                        C1 = A[2*S-1:S] / B[S-1:0];
                        C2 = A[3*S-1:2*S] / B[S-1:0];
                        C3 = A[4*S-1:3*S] / B[S-1:0];
                        C4 = A[5*S-1:4*S] / B[S-1:0];
                        C5 = A[6*S-1:5*S] / B[S-1:0];

                        alu_out_temp = {C5, C4, C3, C2, C1, C0};
                    end
                    // case suma vector vector
                    2'b10: begin
                        C0 = A[S-1:0] + B[S-1:0];
                        C1 = A[2*S-1:S] + B[2*S-1:S];
                        C2 = A[3*S-1:2*S] + B[3*S-1:2*S];
                        C3 = A[4*S-1:3*S] + B[4*S-1:3*S];
                        C4 = A[5*S-1:4*S] + B[5*S-1:4*S];
                        C5 = A[6*S-1:5*S] + B[6*S-1:5*S];

                        alu_out_temp = {C5, C4, C3, C2, C1, C0};
                    end
                    default: begin
                        alu_out_temp = 'b0;
                    end
                endcase 
        endcase
    end

    // resultado de la alu_6lanes
    assign C = alu_out_temp;
    // resultado de la bandera Zero
    assign flagZ = flagZ_aux;
endmodule : alu_6lanes
