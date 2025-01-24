`timescale 1ns / 1ps

module nonblock_assgn_tb;

    // Testbench signals
    reg [7:0] c, d;           // Inputs to the DUT
    reg clk;                  // Clock signal
    wire [7:0] sw_c, sw_d;    // Outputs from the DUT

    // Instantiate the design under test (DUT)
    nonblock_assgn dut (
        .c(c),
        .d(d),
        .clk(clk),
        .sw_c(sw_c),
        .sw_d(sw_d)
    );

    // Clock generation: 10ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // Stimulus
    initial begin
        // Monitor values
        $monitor("Time=%0t | c=%b d=%b | sw_c=%b sw_d=%b", 
                 $time, c, d, sw_c, sw_d);

        // Initialize inputs
        c = 8'b00000001;  // 1
        d = 8'b00000010;  // 2
        #10;              // Wait for 10ns

        // Change inputs
        c = 8'b00000101;  // 5
        d = 8'b00001000;  // 8
        #10;

        // Change inputs again
        c = 8'b11111111;  // 255
        d = 8'b00000000;  // 0
        #10;

        // Finish simulation
        $stop;
    end

endmodule