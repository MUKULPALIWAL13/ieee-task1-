`timescale 1ns/1ps

module mytb;
    // Testbench signals
    reg [15:0] i_a, i_b;
    wire [15:0] o_res;
    wire overflow;
    reg clk, rst;

    // Instantiate the fpadd module
    fpadd uut (
        .clk(clk),
        .rst(rst),
        .i_a(i_a),
        .i_b(i_b),
        .o_res(o_res),
        .overflow(overflow)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Generate a clock with a period of 10ns
    end

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        i_a = 0;
        i_b = 0;

        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Test Case 1
        i_a = 16'b0100000000100000; i_b = 16'b1010000100100110;  // Normal addition (positive numbers)
        #10;
        $display("Test Case 1: i_a = %b, i_b = %b, o_res = %b, overflow = %b", i_a, i_b, o_res, overflow);

        // Test Case 2
        i_a = 16'b0000000000000000; i_b = 16'b0100000000100000;  // Zero input
        #10;
        $display("Test Case 2: i_a = %b, i_b = %b, o_res = %b, overflow = %b", i_a, i_b, o_res, overflow);

        // Test Case 3
        i_a = 16'b1100000000100000; i_b = 16'b1100000001000000;  // Negative numbers
        #10;
        $display("Test Case 3: i_a = %b, i_b = %b, o_res = %b, overflow = %b", i_a, i_b, o_res, overflow);

        // Test Case 4 (NaN)
        i_a = 16'b0111111111100000; i_b = 16'b0111111111100000;  // NaN (Not a Number)
        #10;
        $display("Test Case 4: i_a = %b, i_b = %b, o_res = %b, overflow = %b", i_a, i_b, o_res, overflow);

        // Test Case 5 (Infinity)
        i_a = 16'b0111111111000000; i_b = 16'b0111111111000000;  // Infinity
        #10;
        $display("Test Case 5: i_a = %b, i_b = %b, o_res = %b, overflow = %b", i_a, i_b, o_res, overflow);

        // Finish the simulation
        $finish;
    end
endmodule
