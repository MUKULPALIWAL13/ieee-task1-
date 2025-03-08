module tb_decimal_to_ieee754;
    reg [31:0] decimal;
    wire [31:0] ieee754;
    wire [22:0] mantissa;

    // Instantiate the conversion module
    decimal_to_ieee754 uut (
        .decimal(decimal),
        .ieee754(ieee754),.mantissa(mantissa)
    );

    initial begin
        $dumpfile("decimal_to_ieee754.vcd");
        $dumpvars(0, tb_decimal_to_ieee754);

        // Test cases
        decimal = 32'd0; #10;
        $display("ieee754 = %b | mantissa = %b",ieee754,mantissa);
        decimal = -32'd1; #10;
        $display("ieee754 = %b | mantissa = %b",ieee754,mantissa);
        decimal = 32'd1; #10;
       $display("ieee754 = %b | mantissa = %b",ieee754,mantissa);
        decimal = -32'd12345; #10;
       $display("ieee754 = %b | mantissa = %b",ieee754,mantissa);
        decimal = 32'd12345; #10;
       $display("ieee754 = %b | mantissa = %b",ieee754,mantissa);
        decimal = 32'd100000; #10;
       $display("ieee754 = %b | mantissa = %b",ieee754,mantissa);

        $finish;
    end
endmodule
