module tb_binary_to_floatingpoint;
    reg [31:0] decimal_input;
    wire [31:0] float_output;

    binary_to_floatingpoint uut (
        .decimal(decimal_input),
        .floatingpoint(float_output)
    );

    initial begin
        $monitor("Decimal: %d, Floating-Point: %b", decimal_input, float_output);

        decimal_input = 32'd10;   #10;
        decimal_input = 32'd25;   #10;
        decimal_input = 32'd100;  #10;
        decimal_input = 32'd0;    #10;
        decimal_input = 32'd255;  #10;
        
        $stop;
    end
endmodule
