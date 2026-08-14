// -----------------------------------------------------------------------
// DECODER
// 2x4 decoder that enables one of the four ALU sub-blocks based on the
// most significant 2 bits of the ALU_FUNC control bus (ALU_FUNC[3:2]).
// -----------------------------------------------------------------------
module DECODER (
    input  wire [1:0] ALU_FUNC,      // = top-level ALU_FUNC[3:2]

    output reg         Arith_Enable,
    output reg         Logic_Enable,
    output reg         CMP_Enable,
    output reg         SHIFT_Enable
);

always @(*) begin
    // default all enables low, then set the one that applies
    Arith_Enable = 1'b0;
    Logic_Enable = 1'b0;
    CMP_Enable   = 1'b0;
    SHIFT_Enable = 1'b0;

    case (ALU_FUNC)
        2'b00 : Arith_Enable = 1'b1;
        2'b01 : Logic_Enable = 1'b1;
        2'b10 : CMP_Enable   = 1'b1;
        2'b11 : SHIFT_Enable = 1'b1;
        default : ; // all remain 0
    endcase
end

endmodule
