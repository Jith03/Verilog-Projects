// ============================================================
// Module      : alu_16b
// Description : 16-bit ALU supporting unsigned arithmetic,
//               logic, compare and shift operations.
//               ALU_OUT and all flags are registered (synchronous).
// ============================================================
module alu_16b (
    input  wire        CLK,
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire [3:0]  ALU_FUN,

    output reg  [15:0] ALU_OUT,
    output reg          Carry_Flag,
    output reg          Arith_Flag,
    output reg          Logic_Flag,
    output reg          CMP_Flag,
    output reg          Shift_Flag
);

    // Opcode encoding (per assignment table)
    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam MUL  = 4'b0010;
    localparam DIV  = 4'b0011;
    localparam AND_ = 4'b0100;
    localparam OR_  = 4'b0101;
    localparam NAND_ = 4'b0110;
    localparam NOR_  = 4'b0111;
    localparam XOR_  = 4'b1000;
    localparam XNOR_ = 4'b1001;
    localparam CMP_EQ = 4'b1010;
    localparam CMP_GT = 4'b1011;
    localparam CMP_LT = 4'b1100;
    localparam SHR    = 4'b1101; // shift right (A >> 1)
    localparam SHL    = 4'b1110; // shift left  (A << 1)
    // 4'b1111 and any other value -> default (ALU_OUT = 0)

    // Wider intermediate results so we can capture carry/borrow
    wire [16:0] add_res = {1'b0, A} + {1'b0, B};       // bit16 = carry out
    wire [16:0] sub_res = {1'b0, A} - {1'b0, B};       // bit16 = borrow
    wire [31:0] mul_res = A * B;                        // truncated to 16b
    wire [15:0] div_res = (B == 16'd0) ? 16'hFFFF : (A / B); // guard /0

    always @(posedge CLK) begin
        // Defaults every cycle; overwritten by the case branches below
        Carry_Flag <= 1'b0;
        Arith_Flag <= 1'b0;
        Logic_Flag <= 1'b0;
        CMP_Flag   <= 1'b0;
        Shift_Flag <= 1'b0;

        case (ALU_FUN)
            ADD: begin
                ALU_OUT    <= add_res[15:0];
                Carry_Flag <= add_res[16];
                Arith_Flag <= 1'b1;
            end
            SUB: begin
                ALU_OUT    <= sub_res[15:0];
                Carry_Flag <= sub_res[16]; // borrow
                Arith_Flag <= 1'b1;
            end
            MUL: begin
                ALU_OUT    <= mul_res[15:0];
                Carry_Flag <= |mul_res[31:16]; // overflow beyond 16 bits
                Arith_Flag <= 1'b1;
            end
            DIV: begin
                ALU_OUT    <= div_res;
                Carry_Flag <= (B == 16'd0); // divide-by-zero indicator
                Arith_Flag <= 1'b1;
            end
            AND_: begin
                ALU_OUT    <= A & B;
                Logic_Flag <= 1'b1;
            end
            OR_: begin
                ALU_OUT    <= A | B;
                Logic_Flag <= 1'b1;
            end
            NAND_: begin
                ALU_OUT    <= ~(A & B);
                Logic_Flag <= 1'b1;
            end
            NOR_: begin
                ALU_OUT    <= ~(A | B);
                Logic_Flag <= 1'b1;
            end
            XOR_: begin
                ALU_OUT    <= A ^ B;
                Logic_Flag <= 1'b1;
            end
            XNOR_: begin
                ALU_OUT    <= ~(A ^ B);
                Logic_Flag <= 1'b1;
            end
            CMP_EQ: begin
                ALU_OUT  <= (A == B) ? 16'd1 : 16'd0;
                CMP_Flag <= 1'b1;
            end
            CMP_GT: begin
                ALU_OUT  <= (A > B) ? 16'd2 : 16'd0;
                CMP_Flag <= 1'b1;
            end
            CMP_LT: begin
                ALU_OUT  <= (A < B) ? 16'd3 : 16'd0;
                CMP_Flag <= 1'b1;
            end
            SHR: begin
                ALU_OUT    <= A >> 1;
                Shift_Flag <= 1'b1;
            end
            SHL: begin
                ALU_OUT    <= A << 1;
                Shift_Flag <= 1'b1;
            end
            default: begin
                ALU_OUT <= 16'b0; // undefined opcode -> 0, all flags low
            end
        endcase
    end

endmodule
