// -----------------------------------------------------------------------
// SHIFT_UNIT
// A>>1 / A<<1 / B>>1 / B<<1.
// Purely combinational - ALU_TOP registers the final result.
// -----------------------------------------------------------------------
module SHIFT_UNIT #(
    parameter IN_DATA_WIDTH  = 16,
    parameter OUT_DATA_WIDTH = 16
)
(
    input  wire signed [IN_DATA_WIDTH-1:0]  A,
    input  wire signed [IN_DATA_WIDTH-1:0]  B,
    input  wire [1:0]                       ALU_FUN,
    input  wire                             EN,

    output reg  signed [OUT_DATA_WIDTH-1:0] ALU_Shift,
    output reg                              Shift_Flag
);

always @(*) begin
    if (EN) begin
        Shift_Flag = 1'b1;
        case (ALU_FUN)
            2'b00 : ALU_Shift = A >> 1;
            2'b01 : ALU_Shift = A << 1;
            2'b10 : ALU_Shift = B >> 1;
            2'b11 : ALU_Shift = B << 1;
            default : ALU_Shift = {OUT_DATA_WIDTH{1'b0}};
        endcase
    end
    else begin
        ALU_Shift  = {OUT_DATA_WIDTH{1'b0}};
        Shift_Flag = 1'b0;
    end
end

endmodule
