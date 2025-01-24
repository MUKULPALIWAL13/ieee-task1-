`timescale 1ns/1ps

module tb_dffset();
    reg D;
    reg clk;
    reg set;
    wire Q;

    // Instantiate the DUT (Device Under Test)
    dffset uut (
        .D(D),
        .clk(clk),
        .set(set),
        .Q(Q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with 10ns period
    end

    // Stimulus
    initial begin
        // Open the VCD file
        $dumpfile("dffset_test.vcd");
        $dumpvars(0, tb_dffset);

        // Initialize signals
        D = 0;
        set = 0;

        // Test Case 1: Normal operation
        #10 D = 1; set = 0; // D = 1, normal operation
        #10 D = 0;          // D = 0, normal operation
        #10 D = 1;          // D = 1, normal operation

        // Test Case 2: Set signal high
        #10 set = 1;        // Force Q to 1
        #10 set = 0;        // Release set, Q follows f (testfile)

        // Test Case 3: Toggle D
        #10 D = 0; set = 0; // D = 0
        #10 D = 1;          // D = 1

        // Finish simulation
        #20 $finish;
    end
endmodule
