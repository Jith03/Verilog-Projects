// -----------------------------------------------------------------------
// CMP_UNIT
// NOP / Equal / Greater-than / Less-than.
// Purely combinational - ALU_TOP registers the final result.
//
// Per spec ALU_FUN table:
//   2'b00 (1000) NOP        -> CMP_OUT = 0
//   2'b01 (1001) A == B     -> CMP_OUT = 1 if true else 0
//   2'b10 (1010) A >  B     -> CMP_OUT = 2 if true else 0
//   2'b11 (1011) A <  B     -> CMP_OUT = 3 if true else 0
// CMP_Flag is HIGH for all four cases (comparison ops AND NOP).
// -----------------------------------------------------------------------
module CMP_UNIT #(
    parameter IN_DATA_WIDTH  = 16,
    parameter OUT_DATA_WIDTH = 16
)
(
    input  wire signed [IN_DATA_WIDTH-1:0]  A,
    input  wire signed [IN_DATA_WIDTH-1:0]  B,
    input  wire [1:0]                       ALU_FUN,
    input  wire                             EN,

    output reg  signed [OUT_DATA_WIDTH-1:0] ALU_CMP,
    output reg                              CMP_Flag
);

always @(*) begin
    if (EN) begin
        CMP_Flag = 1'b1; // high for NOP and for every comparison op
        case (ALU_FUN)
            2'b00 : ALU_CMP = {OUT_DATA_WIDTH{1'b0}};              // NOP
            2'b01 : ALU_CMP = (A == B) ? 1 : 0;
            2'b10 : ALU_CMP = (A >  B) ? 2 : 0;
            2'b11 : ALU_CMP = (A <  B) ? 3 : 0;
            default : ALU_CMP = {OUT_DATA_WIDTH{1'b0}};
        endcase
    end
    else begin
        ALU_CMP  = {OUT_DATA_WIDTH{1'b0}};
        CMP_Flag = 1'b0;
    end
end

endmodule
