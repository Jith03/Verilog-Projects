// -----------------------------------------------------------------------
// LOGIC_UNIT
// Boolean AND / OR / NAND / NOR.
// Purely combinational - ALU_TOP registers the final result.
// -----------------------------------------------------------------------
module LOGIC_UNIT #(
    parameter IN_DATA_WIDTH  = 16,
    parameter OUT_DATA_WIDTH = 16
)
(
    input  wire signed [IN_DATA_WIDTH-1:0]  A,
    input  wire signed [IN_DATA_WIDTH-1:0]  B,
    input  wire [1:0]                       ALU_FUN,
    input  wire                             EN,

    output reg  signed [OUT_DATA_WIDTH-1:0] ALU_Logic,
    output reg                              Logic_Flag
);

always @(*) begin
    if (EN) begin
        Logic_Flag = 1'b1;
        case (ALU_FUN)
            2'b00 : ALU_Logic = A & B;
            2'b01 : ALU_Logic = A | B;
            2'b10 : ALU_Logic = ~(A & B);
            2'b11 : ALU_Logic = ~(A | B);
            default : ALU_Logic = {OUT_DATA_WIDTH{1'b0}};
        endcase
    end
    else begin
        ALU_Logic  = {OUT_DATA_WIDTH{1'b0}};
        Logic_Flag = 1'b0;
    end
end

endmodule
