module fsm_tb;
    reg clk;
    reg reset;
    reg in;
    wire out;

    fsm uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        in = 0;

        #10 reset = 0;

        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;

        #20 $finish;
    end

    initial begin
        $monitor("Time=%0d, Reset=%b, Input=%b, Output=%b, State=%b", $time, reset, in, out, uut.present_state);
    end

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, fsm_tb);
    end
endmodule
