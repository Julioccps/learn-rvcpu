`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0]  alu_control;

    // Outputs
    wire [31:0] result;
    wire        zero;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .a(a),
        .b(b),
        .shamt(5'b0), // Not used in current ALU internal logic but present in port
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        // Monitor changes
        $monitor("Time=%0t | Ctrl=%b | A=%h | B=%h | Res=%h | Zero=%b", 
                 $time, alu_control, a, b, result, zero);

        // --- Test ADD ---
        a = 32'h0000_0005; b = 32'h0000_000A; alu_control = 4'b0000; #10;
        if (result !== 32'h0000_000F) $display("ERROR: ADD failed");

        // --- Test SUB ---
        a = 32'h0000_000A; b = 32'h0000_0005; alu_control = 4'b1000; #10;
        if (result !== 32'h0000_0005) $display("ERROR: SUB failed");

        // --- Test SUB resulting in Zero ---
        a = 32'h0000_0007; b = 32'h0000_0007; alu_control = 4'b1000; #10;
        if (zero !== 1'b1) $display("ERROR: Zero flag failed");

        // --- Test SLL (Shift Left) ---
        a = 32'h0000_0001; b = 32'h0000_0004; alu_control = 4'b0001; #10;
        if (result !== 32'h0000_0010) $display("ERROR: SLL failed");

        // --- Test SLT (Set Less Than - Signed) ---
        a = 32'hFFFF_FFFF; b = 32'h0000_0001; alu_control = 4'b0010; #10; // -1 < 1
        if (result !== 32'h0000_0001) $display("ERROR: SLT failed");

        // --- Test SLTU (Set Less Than - Unsigned) ---
        a = 32'hFFFF_FFFF; b = 32'h0000_0001; alu_control = 4'b0011; #10; // MaxInt < 1 is false
        if (result !== 32'h0000_0000) $display("ERROR: SLTU failed");

        // --- Test SRA (Shift Right Arithmetic) ---
        a = 32'h8000_0000; b = 32'h0000_0002; alu_control = 4'b1101; #10; // Sign-extend 1000... to 1110...
        if (result !== 32'hE000_0000) $display("ERROR: SRA failed");

        // --- Test AND ---
        a = 32'hF0F0_F0F0; b = 32'hFFFF_0000; alu_control = 4'b0111; #10;
        if (result !== 32'hF0F0_0000) $display("ERROR: AND failed");

        $display("Testbench complete.");
        $finish;
    end

endmodule
