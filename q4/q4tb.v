`timescale 1ns / 1ps

module block_assgn_tb;

    // Testbench signals
    reg [8:0] a, b;          // Inputs to the DUT
    reg clk;                 // Clock signal
    wire [8:0] sw_a, sw_b;   // Outputs from the DUT

    // Instantiate the design under test (DUT)
    block_assgn dut (
        .a(a),
        .b(b),
        .clk(clk),
        .sw_a(sw_a),
        .sw_b(sw_b)
    );

    // Clock generation: 10ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // Stimulus
    initial begin
        // Monitor values
        $monitor("Time=%0t | a=%b b=%b | sw_a=%b sw_b=%b", 
                 $time, a, b, sw_a, sw_b);

        // Initialize inputs
        a = 9'b000000001; // 1
        b = 9'b000000010; // 2
        #10;              // Wait for 10ns

        // Change inputs
        a = 9'b000001011; // 11
        b = 9'b000010000; // 16
        #10;

        // Change inputs again
        a = 9'b111111111; // 511
        b = 9'b000000000; // 0
        #10;

        // Finish simulation
        $stop;
    end

endmodule