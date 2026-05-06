`timescale 1ns / 1ps

module reg_file_tb;

    // Signals
    reg         clk;
    reg         reg_write;
    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] write_data;
    wire [31:0] read_data1, read_data2;

    // Instantiate Register File
    reg_file uut (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Monitor
        $monitor("Time=%0t | WE=%b | rd=%d | data=%h | rs1=%d (v1=%h) | rs2=%d (v2=%h)", 
                 $time, reg_write, rd, write_data, rs1, read_data1, rs2, read_data2);

        // Initialize
        reg_write = 0; rs1 = 0; rs2 = 0; rd = 0; write_data = 0;
        #10;

        // Test 1: Write to x1
        rd = 5'd1; write_data = 32'hDEADBEEF; reg_write = 1;
        #10;
        reg_write = 0;
        
        // Test 2: Read from x1
        rs1 = 5'd1;
        #10;
        if (read_data1 !== 32'hDEADBEEF) $display("ERROR: Read from x1 failed");

        // Test 3: Write to x2
        rd = 5'd2; write_data = 32'hCAFEBABE; reg_write = 1;
        #10;
        reg_write = 0;

        // Test 4: Dual Read (x1 and x2)
        rs1 = 5'd1; rs2 = 5'd2;
        #10;
        if (read_data1 !== 32'hDEADBEEF || read_data2 !== 32'hCAFEBABE) 
            $display("ERROR: Dual read failed");

        // Test 5: Attempt to write to x0 (should stay zero)
        rd = 5'd0; write_data = 32'hFFFFFFFF; reg_write = 1;
        #10;
        reg_write = 0;
        rs1 = 5'd0;
        #10;
        if (read_data1 !== 32'h0) $display("ERROR: x0 should always be 0");

        $display("Register File Testbench complete.");
        $finish;
    end

endmodule
