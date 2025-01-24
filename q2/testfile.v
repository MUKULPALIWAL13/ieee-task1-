module testfile (
    input wire D,     // Data input
    input wire clk,   // Clock input
    input wire clear, // Asynchronous clear
    output reg Q      // Output
);

    // Initialize Q at the start
    initial begin
        Q = 0; // Set initial value of Q
    end

    always @(posedge clk or posedge clear) begin
        if (clear)
            Q <= 1'b0;  // Clear output
        else
            Q <= D;     // Latch D on positive clock edge
    end

    initial begin
        $dumpfile("testfile_tb.vcd");
        $dumpvars(0, testfile_tb);
    end
endmodule
