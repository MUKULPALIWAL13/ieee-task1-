`timescale 1ns / 1ps

module mulfptb;
    reg clk;
    reg rst;
    reg [15:0] i_a;
    reg [15:0] i_b;
    wire [15:0] o_res;
    wire o_res_vld;
    wire overflow;
    wire underflow;
    wire exception;

    // Instantiate the multiplier12 module
    multiplier12 uut (
        .clk(clk), 
        .rst(rst), 
        .i_a(i_a), 
        .i_b(i_b), 
        .o_res(o_res), 
        .o_res_vld(o_res_vld), 
        .overflow(overflow), 
        .underflow(underflow), 
        .exception(exception)
    );

    // Clock generation (10 ns period)
    always #10 clk = ~clk;

    // Initial stimulus
    initial begin
        $dumpfile("mulfptb.vcd");
        $dumpvars(0, mulfptb);

        // Initialize signals
        clk = 0;
        rst = 1;
        i_a = 0;
        i_b = 0;

        #30 rst = 0; // Release reset after 20 time units
        
        // Test Cases
        // #10 i_a = 16'b0_01111_0000000000; i_b = 16'b0_10000_0000000000; // 2.0 (normalized FP)
        
        // #20 i_a = 16'b0_01110_1000000000;  i_b = 16'b0_01101_1100000000; // 0.4375

        #20 i_a = 16'b1_01111_0000000000; // -1.0
         i_b = 16'b0_01111_0000000000; // 1.0

        // #20 i_a = 16'b0_00000_0000000000; // Zero
        // #10 i_b = 16'b0_10001_0000000000; // 4.0

        // #20 i_a = 16'b0_11110_1111111111; // Large positive number
        // #10 i_b = 16'b0_11110_1111111111; // Large positive number (to check overflow)

        #50 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t | i_a=%b | i_b=%b | o_res=%b | o_res_vld=%b | overflow=%b | underflow=%b | exception=%b", 
                 $time, i_a, i_b, o_res, o_res_vld, overflow, underflow, exception);
    end
endmodule
