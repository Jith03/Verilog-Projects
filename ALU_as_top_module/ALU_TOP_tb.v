`timescale 1ns/1ps
// -----------------------------------------------------------------------
// ALU_TOP_tb
// Self-checking testbench: 28 test cases covering signed arithmetic
// (add/sub/mul/div x 4 sign combos each), logic, compare, shift and NOP.
// Clock: 100 KHz (10000 ns period), 40% low / 60% high duty cycle.
// -----------------------------------------------------------------------
module ALU_TOP_tb;

localparam DATA_WIDTH = 16;

// 100 KHz -> period = 10000 ns ; 40% low = 4000 ns, 60% high = 6000 ns
localparam T_LOW  = 4000;
localparam T_HIGH = 6000;
localparam T_CLK  = T_LOW + T_HIGH;

/**********************************************************************/
/*************************** TB Signals ******************************/
/**********************************************************************/
reg                          CLK_TB;
reg                          RST_TB;
reg  signed [DATA_WIDTH-1:0] A_TB;
reg  signed [DATA_WIDTH-1:0] B_TB;
reg  [3:0]                   ALU_FUNC_TB;

wire signed [DATA_WIDTH-1:0] Arith_OUT_TB;
wire                         Arith_Flag_TB;
wire signed [DATA_WIDTH-1:0] Logic_OUT_TB;
wire                         Logic_Flag_TB;
wire signed [DATA_WIDTH-1:0] CMP_OUT_TB;
wire                         CMP_Flag_TB;
wire signed [DATA_WIDTH-1:0] SHIFT_OUT_TB;
wire                         SHIFT_Flag_TB;

integer pass_count = 0;
integer fail_count = 0;

/**********************************************************************/
/******************************** DUT ********************************/
/**********************************************************************/
ALU_TOP #(
    .DATA_WIDTH (DATA_WIDTH)
) DUT (
    .CLK        (CLK_TB),
    .RST        (RST_TB),
    .A          (A_TB),
    .B          (B_TB),
    .ALU_FUNC   (ALU_FUNC_TB),

    .Arith_OUT  (Arith_OUT_TB),
    .Arith_Flag (Arith_Flag_TB),
    .Logic_OUT  (Logic_OUT_TB),
    .Logic_Flag (Logic_Flag_TB),
    .CMP_OUT    (CMP_OUT_TB),
    .CMP_Flag   (CMP_Flag_TB),
    .SHIFT_OUT  (SHIFT_OUT_TB),
    .SHIFT_Flag (SHIFT_Flag_TB)
);

/**********************************************************************/
/*************************** Clock generation ************************/
/**********************************************************************/
initial CLK_TB = 1'b0;
always begin
    #T_LOW  CLK_TB = 1'b1;
    #T_HIGH CLK_TB = 1'b0;
end

/**********************************************************************/
/****************************** Tasks ********************************/
/**********************************************************************/

// Drive inputs at a negedge (safe setup time before the next posedge),
// then sample the registered outputs one clock later.
task run_test;
    input [8*40-1:0]         test_name;
    input signed [DATA_WIDTH-1:0] a_in;
    input signed [DATA_WIDTH-1:0] b_in;
    input [3:0]               func_in;
    input signed [DATA_WIDTH-1:0] exp_out;
    input                      exp_flag;
    input [1:0]                unit_sel; // 0=Arith 1=Logic 2=CMP 3=Shift
    reg signed [DATA_WIDTH-1:0] act_out;
    reg                         act_flag;
    begin
        @(negedge CLK_TB);
        A_TB        = a_in;
        B_TB        = b_in;
        ALU_FUNC_TB = func_in;

        @(posedge CLK_TB); // output register captures result here
        #1;                // small delta for the registered output to settle

        case (unit_sel)
            2'd0 : begin act_out = Arith_OUT_TB; act_flag = Arith_Flag_TB; end
            2'd1 : begin act_out = Logic_OUT_TB; act_flag = Logic_Flag_TB; end
            2'd2 : begin act_out = CMP_OUT_TB;   act_flag = CMP_Flag_TB;   end
            default : begin act_out = SHIFT_OUT_TB; act_flag = SHIFT_Flag_TB; end
        endcase

        if (act_out === exp_out && act_flag === exp_flag) begin
            pass_count = pass_count + 1;
            $display("*** %0s -- A=%0d B=%0d -- PASSED : OUT=%0d FLAG=%0b",
                       test_name, a_in, b_in, act_out, act_flag);
        end
        else begin
            fail_count = fail_count + 1;
            $display("*** %0s -- A=%0d B=%0d -- FAILED : OUT=%0d (exp %0d) FLAG=%0b (exp %0b)",
                       test_name, a_in, b_in, act_out, exp_out, act_flag, exp_flag);
        end
    end
endtask

/**********************************************************************/
/**************************** Stimulus *******************************/
/**********************************************************************/
initial begin
    // $dumpfile("ALU_TOP_tb.vcd");
    // $dumpvars(0, ALU_TOP_tb);

    A_TB        = 0;
    B_TB        = 0;
    ALU_FUNC_TB = 0;

    // Asynchronous active-low reset pulse
    RST_TB = 1'b0;
    #100;
    RST_TB = 1'b1;

    // ---------------- Signed Arithmetic Addition (0000) ----------------
    run_test("Addition -- NEG + NEG",  -16'sd4,  -16'sd10, 4'b0000, -16'sd14, 1'b1, 2'd0);
    run_test("Addition -- POS + NEG",   16'sd10,  -16'sd3, 4'b0000,  16'sd7,  1'b1, 2'd0);
    run_test("Addition -- NEG + POS",  -16'sd10,   16'sd3, 4'b0000, -16'sd7, 1'b1, 2'd0);
    run_test("Addition -- POS + POS",   16'sd10,   16'sd3, 4'b0000, 16'sd13, 1'b1, 2'd0);

    // -------------- Signed Arithmetic Subtraction (0001) ---------------
    run_test("Subtraction -- NEG - NEG", -16'sd4,  -16'sd10, 4'b0001,  16'sd6,  1'b1, 2'd0);
    run_test("Subtraction -- POS - NEG",  16'sd10,  -16'sd3, 4'b0001,  16'sd13, 1'b1, 2'd0);
    run_test("Subtraction -- NEG - POS", -16'sd10,   16'sd3, 4'b0001, -16'sd13, 1'b1, 2'd0);
    run_test("Subtraction -- POS - POS",  16'sd10,   16'sd3, 4'b0001,  16'sd7,  1'b1, 2'd0);

    // ------------- Signed Arithmetic Multiplication (0010) --------------
    run_test("Multiplication -- NEG * NEG", -16'sd4, -16'sd3, 4'b0010,  16'sd12, 1'b1, 2'd0);
    run_test("Multiplication -- POS * NEG",  16'sd4, -16'sd3, 4'b0010, -16'sd12, 1'b1, 2'd0);
    run_test("Multiplication -- NEG * POS", -16'sd4,  16'sd3, 4'b0010, -16'sd12, 1'b1, 2'd0);
    run_test("Multiplication -- POS * POS",  16'sd4,  16'sd3, 4'b0010,  16'sd12, 1'b1, 2'd0);

    // ---------------- Signed Arithmetic Division (0011) -----------------
    run_test("Division -- NEG / NEG", -16'sd12, -16'sd3, 4'b0011,  16'sd4,  1'b1, 2'd0);
    run_test("Division -- POS / NEG",  16'sd12, -16'sd3, 4'b0011, -16'sd4,  1'b1, 2'd0);
    run_test("Division -- NEG / POS", -16'sd12,  16'sd3, 4'b0011, -16'sd4,  1'b1, 2'd0);
    run_test("Division -- POS / POS",  16'sd12,  16'sd3, 4'b0011,  16'sd4,  1'b1, 2'd0);

    // -------------------------- Logical Ops ------------------------------
    run_test("Logic -- AND",  16'h FF00, 16'h 0FF0, 4'b0100, 16'h 0F00, 1'b1, 2'd1);
    run_test("Logic -- OR",   16'h FF00, 16'h 00FF, 4'b0101, 16'h FFFF, 1'b1, 2'd1);
    run_test("Logic -- NAND", 16'h FF00, 16'h 0FF0, 4'b0110, 16'h F0FF, 1'b1, 2'd1);
    run_test("Logic -- NOR",  16'h FF00, 16'h 00FF, 4'b0111, 16'h 0000, 1'b1, 2'd1);

    // ------------------------- Compare Ops -------------------------------
    run_test("Compare -- Equal",   16'sd5, 16'sd5, 4'b1001, 16'sd1, 1'b1, 2'd2);
    run_test("Compare -- Greater", 16'sd7, 16'sd3, 4'b1010, 16'sd2, 1'b1, 2'd2);
    run_test("Compare -- Less",    16'sd2, 16'sd9, 4'b1011, 16'sd3, 1'b1, 2'd2);

    // -------------------------- Shift Ops --------------------------------
    run_test("Shift -- A >> 1", 16'h00F0, 16'h0000, 4'b1100, 16'h0078, 1'b1, 2'd3);
    run_test("Shift -- A << 1", 16'h00F0, 16'h0000, 4'b1101, 16'h01E0, 1'b1, 2'd3);
    run_test("Shift -- B >> 1", 16'h0000, 16'h00F0, 4'b1110, 16'h0078, 1'b1, 2'd3);
    run_test("Shift -- B << 1", 16'h0000, 16'h00F0, 4'b1111, 16'h01E0, 1'b1, 2'd3);

    // ------------------------------ NOP -----------------------------------
    run_test("NOP", 16'sd25, 16'sd7, 4'b1000, 16'sd0, 1'b1, 2'd2);

    // ------------------------------ Summary ---------------------------------
    #100;
    $display("---------------------------------------------------------------");
    $display("TOTAL = %0d  PASSED = %0d  FAILED = %0d", pass_count + fail_count, pass_count, fail_count);
    $display("---------------------------------------------------------------");

    $finish;
end

endmodule
