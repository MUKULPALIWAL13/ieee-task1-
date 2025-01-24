`timescale 1ns/1ps

module testfile_tb;

    reg D, clk, clear; // Inputs to the flip-flop
    wire Q;             // Output of the flip-flop

    // Instantiate the testfile module
    testfile uut (
        .D(D),
        .clk(clk),
        .clear(clear),
        .Q(Q)
    );

    // Clock generation (50 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 10ns
    end

    // Stimulus
    initial begin
        // Initialize inputs
        D = 0; clear = 0;

        // Test case 1: Normal operation
        #15 D = 1;
        #20 D = 0;

        // Test case 2: Clear operation
        #25 clear = 1; // Assert clear
        #10 clear = 0; // Deassert clear

        // Test case 3: D = 1 and clear = 1
        #10 D = 1; clear = 1; // Both D and clear are 1
        #10 clear = 0; // Deassert clear

        // Test case 4: Normal operation resumes
        #15 D = 1;

        // Finish simulation after 100ns
        #100 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %0dns | D = %b | clk = %b | clear = %b | Q = %b", $time, D, clk, clear, Q);
    end

    // Generate VCD file
    initial begin
        $dumpfile("testfile_tb.vcd"); // Specify the name of the VCD file
        $dumpvars(0, testfile_tb);    // Dump all variables in the testbench
    end

endmodule
