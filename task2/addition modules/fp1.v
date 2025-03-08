module decimal_to_ieee754(
    input [31:0] decimal,       // Input decimal number (32-bit integer)
    output reg [31:0] ieee754 ,output reg [22:0] mantissa  // Output IEEE 754 single-precision format
);
    reg [31:0] abs_value;       // Absolute value of the input
    reg [7:0] exponent;         // Exponent field
            // Mantissa field
    integer i;
    reg loop_break;             // Loop break condition

    always @(*) begin
        // Initialize variables
        abs_value = decimal[31] ? -decimal : decimal; // Get the absolute value
        ieee754 = 32'b0;                             // Clear the output
        loop_break = 0;                              // Reset loop_break flag

        // Handle special cases
        if (decimal == 32'b0) begin
            ieee754 = 32'b0; // Zero is represented as all bits zero
        end else begin
            // Find the position of the highest set bit (leftmost 1)
            for (i = 31; i >= 0; i = i - 1) begin
                if (!loop_break && abs_value[i]) begin
                    exponent = i + 127; // Bias the exponent by 127
                    mantissa = abs_value << (23 - i); // Normalize the mantissa
                    loop_break = 1; // Set loop break flag
                end
            end

            // Set the sign bit, exponent, and mantissa
            ieee754[31] = decimal[31];        // Sign bit
            ieee754[30:23] = exponent;       // Exponent field
            ieee754[22:0] = mantissa;  // Normalized mantissa (23 bits)
        end
    end
endmodule
