module tb_myshiftreg;

    reg clk;
    reg clr;
    reg A;
    reg ena;
    reg load;
    reg [3:0] data;

    wire [3:0] Q;
    wire E;

    myshiftreg uut (
        .clk(clk),
        .clr(clr),
        .load(load),
        .data(data),
        .ena(ena),
        .A(A),
        .Q(Q),
        .E(E)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("shiftreg.vcd");
        $dumpvars(0, tb_myshiftreg);

        clk = 0;
        clr = 0;
        load = 0;
        ena = 0;
        A = 0;
        data = 4'b0000;

        $monitor("Time=%0t | Q=%b | E=%b | B=%b | C=%b | D=%b | A=%b", $time, Q, E, uut.B, uut.C, uut.D, A);

        clr = 1;
        #10 clr = 0;
        
        load = 1;
        data = 4'b1101;
        #10 load = 0;

        ena = 1;
        A = 1;
        #10 ena = 0;

        ena = 1;
        A = 0;
        #10 ena = 0;

        load = 1;
        data = 4'b1010;
        #10 load = 0;

        ena = 1;
        A = 1;
        #10 ena = 0;

        clr = 1;
        #10 clr = 0;

        $finish;
    end

endmodule
