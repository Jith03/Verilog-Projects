// -----------------------------------------------------------------------
// ALU_TOP
// Top-level 16-bit ALU. Instantiates the decoder and the four functional
// units (all combinational) and registers their outputs on every rising
// edge of CLK. All registers are cleared asynchronously by active-low RST.
// -----------------------------------------------------------------------
module ALU_TOP #(
    parameter DATA_WIDTH = 16
)
(
    input  wire                     CLK,
    input  wire                     RST,          // async active-low
    input  wire signed [DATA_WIDTH-1:0] A,
    input  wire signed [DATA_WIDTH-1:0] B,
    input  wire [3:0]               ALU_FUNC,

    output reg  signed [DATA_WIDTH-1:0] Arith_OUT,
    output reg                          Arith_Flag,
    output reg  signed [DATA_WIDTH-1:0] Logic_OUT,
    output reg                          Logic_Flag,
    output reg  signed [DATA_WIDTH-1:0] CMP_OUT,
    output reg                          CMP_Flag,
    output reg  signed [DATA_WIDTH-1:0] SHIFT_OUT,
    output reg                          SHIFT_Flag
);

// block-enable wires driven by the decoder
wire Arith_Enable, Logic_Enable, CMP_Enable, SHIFT_Enable;

// combinational results/flags coming out of each functional unit
wire signed [DATA_WIDTH-1:0] arith_comb, logic_comb, cmp_comb, shift_comb;
wire                         arith_flag_comb, logic_flag_comb, cmp_flag_comb, shift_flag_comb;

// ------------------------------------------------------------------
// Decoder: enables exactly one block based on ALU_FUNC[3:2]
// ------------------------------------------------------------------
DECODER U_decoder (
    .ALU_FUNC     (ALU_FUNC[3:2]),
    .Arith_Enable (Arith_Enable),
    .Logic_Enable (Logic_Enable),
    .CMP_Enable   (CMP_Enable),
    .SHIFT_Enable (SHIFT_Enable)
);

// ------------------------------------------------------------------
// Functional units
// ------------------------------------------------------------------
ARITHMATIC_UNIT #(
    .IN_DATA_WIDTH  (DATA_WIDTH),
    .OUT_DATA_WIDTH (DATA_WIDTH)
) U_arithmetic_unit (
    .A          (A),
    .B          (B),
    .ALU_FUN    (ALU_FUNC[1:0]),
    .EN         (Arith_Enable),
    .ALU_Arith  (arith_comb),
    .Arith_Flag (arith_flag_comb)
);

LOGIC_UNIT #(
    .IN_DATA_WIDTH  (DATA_WIDTH),
    .OUT_DATA_WIDTH (DATA_WIDTH)
) U_logic_unit (
    .A          (A),
    .B          (B),
    .ALU_FUN    (ALU_FUNC[1:0]),
    .EN         (Logic_Enable),
    .ALU_Logic  (logic_comb),
    .Logic_Flag (logic_flag_comb)
);

CMP_UNIT #(
    .IN_DATA_WIDTH  (DATA_WIDTH),
    .OUT_DATA_WIDTH (DATA_WIDTH)
) U_cmp_unit (
    .A        (A),
    .B        (B),
    .ALU_FUN  (ALU_FUNC[1:0]),
    .EN       (CMP_Enable),
    .ALU_CMP  (cmp_comb),
    .CMP_Flag (cmp_flag_comb)
);

SHIFT_UNIT #(
    .IN_DATA_WIDTH  (DATA_WIDTH),
    .OUT_DATA_WIDTH (DATA_WIDTH)
) U_shift_unit (
    .A          (A),
    .B          (B),
    .ALU_FUN    (ALU_FUNC[1:0]),
    .EN         (SHIFT_Enable),
    .ALU_Shift  (shift_comb),
    .Shift_Flag (shift_flag_comb)
);

// ------------------------------------------------------------------
// Single registered stage for all outputs, async active-low reset
// ------------------------------------------------------------------
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        Arith_OUT  <= {DATA_WIDTH{1'b0}};
        Arith_Flag <= 1'b0;
        Logic_OUT  <= {DATA_WIDTH{1'b0}};
        Logic_Flag <= 1'b0;
        CMP_OUT    <= {DATA_WIDTH{1'b0}};
        CMP_Flag   <= 1'b0;
        SHIFT_OUT  <= {DATA_WIDTH{1'b0}};
        SHIFT_Flag <= 1'b0;
    end
    else begin
        Arith_OUT  <= arith_comb;
        Arith_Flag <= arith_flag_comb;
        Logic_OUT  <= logic_comb;
        Logic_Flag <= logic_flag_comb;
        CMP_OUT    <= cmp_comb;
        CMP_Flag   <= cmp_flag_comb;
        SHIFT_OUT  <= shift_comb;
        SHIFT_Flag <= shift_flag_comb;
    end
end

endmodule
