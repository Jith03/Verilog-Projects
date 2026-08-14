// -----------------------------------------------------------------------
// ARITHMETIC_UNIT
// Signed Addition / Subtraction / Multiplication / Division.
// Purely combinational - ALU_TOP is the single place that registers
// results, per the "all outputs are registered" spec requirement.
// -----------------------------------------------------------------------
module ARITHMATIC_UNIT #(
    parameter IN_DATA_WIDTH  = 16,
    parameter OUT_DATA_WIDTH = 16
)
(
    input  wire signed [IN_DATA_WIDTH-1:0]  A,
    input  wire signed [IN_DATA_WIDTH-1:0]  B,
    input  wire [1:0]                       ALU_FUN,
    input  wire                             EN,

    output reg  signed [OUT_DATA_WIDTH-1:0] ALU_Arith,
    output reg                              Arith_Flag
);

always @(*) begin
    if (EN) begin
        Arith_Flag = 1'b1;
        case (ALU_FUN)
            2'b00 : ALU_Arith = A + B;   // signed addition
            2'b01 : ALU_Arith = A - B;   // signed subtraction
            2'b10 : ALU_Arith = A * B;   // signed multiplication
            2'b11 : begin                // signed division, guarded against /0
                // NOTE: a ternary here (cond ? A/B : {W{1'b0}}) is a classic Verilog
                // trap - mixing a signed operand with an unsigned concatenation
                // forces the WHOLE expression unsigned, silently corrupting the
                // signed division. Using if/else avoids that pitfall.
                if (B != 0)
                    ALU_Arith = A / B;
                else
                    ALU_Arith = {OUT_DATA_WIDTH{1'b0}};
            end
            default : ALU_Arith = {OUT_DATA_WIDTH{1'b0}};
        endcase
    end
    else begin
        ALU_Arith  = {OUT_DATA_WIDTH{1'b0}};
        Arith_Flag = 1'b0;
    end
end

endmodule
