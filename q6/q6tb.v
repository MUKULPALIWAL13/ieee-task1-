module tb_mymod;
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] S;
    mymod uut (
        .A(A),
        .B(B),
        .S(S)
    );

    initial begin
        A = 8'b00000000; B = 8'b00000000;
        #10 A = 8'b01010101; B = 8'b01010101;
        #10 A = 8'b11111111; B = 8'b11111111;
        #10 A = 8'b10000000; B = 8'b10000000;
        #10 A = 8'b01111111; B = 8'b01111111;
        #10 A = 8'b01000000; B = 8'b10000000;
        #10 A = 8'b10000000; B = 8'b01111111;
        #10;
    end

    initial begin
        $dumpfile("tb_mymod.vcd");
        $dumpvars(0, tb_mymod);
        #100 $finish;
    end
endmodule
