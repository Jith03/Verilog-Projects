// ============================================================
// Waveform Testbench for 16-bit ALU
// Generates VCD file for GTKWave
// ============================================================
`timescale 1us/1ns

module bit_16_ALU_wave_tb;

    reg  [15:0] A, B;
    reg  [3:0]  ALU_FUN;
    reg         CLK;

    wire [15:0] ALU_OUT;
    wire        Carry_Flag, Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag;

    // ---------------- DUT ----------------
    bit_16_ALU DUT (
        .CLK(CLK),
        .A(A),
        .B(B),
        .ALU_FUN(ALU_FUN),
        .ALU_OUT(ALU_OUT),
        .Carry_Flag(Carry_Flag),
        .Arith_Flag(Arith_Flag),
        .Logic_Flag(Logic_Flag),
        .CMP_Flag(CMP_Flag),
        .Shift_Flag(Shift_Flag)
    );

    // ---------------- Clock: 100 kHz ----------------
    initial CLK = 0;
    always #5 CLK = ~CLK;   // 10 us period

    // ---------------- Waveform dump ----------------
    initial begin
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, bit_16_ALU_wave_tb);
    end

    // ---------------- Stimulus ----------------
    initial begin

        // Initialize
        A = 0;
        B = 0;
        ALU_FUN = 0;

        // Wait a little
        #10;

        // ADD : 25 + 10 = 35
        A = 16'd25;
        B = 16'd10;
        ALU_FUN = 4'b0000;
        #10;

        // SUB : 25 - 10 = 15
        A = 16'd25;
        B = 16'd10;
        ALU_FUN = 4'b0001;
        #10;

        // MUL : 12 * 4 = 48
        A = 16'd12;
        B = 16'd4;
        ALU_FUN = 4'b0010;
        #10;

        // DIV : 20 / 4 = 5
        A = 16'd20;
        B = 16'd4;
        ALU_FUN = 4'b0011;
        #10;

        // AND
        A = 16'hFF00;
        B = 16'h0FF0;
        ALU_FUN = 4'b0100;
        #10;

        // OR
        A = 16'hFF00;
        B = 16'h00FF;
        ALU_FUN = 4'b0101;
        #10;

        // NAND
        A = 16'hFF00;
        B = 16'h0FF0;
        ALU_FUN = 4'b0110;
        #10;

        // NOR
        A = 16'hFF00;
        B = 16'h00FF;
        ALU_FUN = 4'b0111;
        #10;

        // XOR
        A = 16'hAAAA;
        B = 16'h5555;
        ALU_FUN = 4'b1000;
        #10;

        // XNOR
        A = 16'hAAAA;
        B = 16'h5555;
        ALU_FUN = 4'b1001;
        #10;

        // CMP EQ
        A = 16'd50;
        B = 16'd50;
        ALU_FUN = 4'b1010;
        #10;

        // CMP GT
        A = 16'd80;
        B = 16'd30;
        ALU_FUN = 4'b1011;
        #10;

        // CMP LT
        A = 16'd10;
        B = 16'd90;
        ALU_FUN = 4'b1100;
        #10;

        // SHR
        A = 16'd16;
        B = 16'd0;
        ALU_FUN = 4'b1101;
        #10;

        // SHL
        A = 16'd16;
        B = 16'd0;
        ALU_FUN = 4'b1110;
        #10;

        // Undefined opcode (NOP)
        A = 16'd123;
        B = 16'd45;
        ALU_FUN = 4'b1111;
        #10;

        // Divide by zero
        A = 16'd10;
        B = 16'd0;
        ALU_FUN = 4'b0011;
        #10;

        // Finish simulation
        #20;
        $finish;
    end

endmodule