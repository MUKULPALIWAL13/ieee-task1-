module msb_finder_trimmed(
    input [31:0] data_in,
    output reg [4:0] msb_position,
    output reg [31:0] trimmed_data,
    output reg found
);
    integer i;
    always @(*) begin
        msb_position = 5'b0;  // Default to 0
        found = 1'b0;         // Default to not found
        trimmed_data = 32'b0; // Initialize trimmed data to zero

        for (i = 31; i >= 0; i = i - 1) begin
            if (data_in[i] == 1 && !found) begin
                msb_position = i;  // Store MSB position
                found = 1'b1;
                trimmed_data = data_in << (31 - i);  // Left-shift to normalize
            end
        end
    end
endmodule

module decimal_to_binary(
    input [31:0] decimal_number,
    output reg [31:0] binary_out
);
    always @(*) begin
        binary_out = decimal_number; // Direct assignment
    end
endmodule

module binary_to_floatingpoint(
    input [31:0] decimal,
    output reg [31:0] floatingpoint
);
    wire [31:0] binary_representation;
    wire [31:0] normalized_data;
    wire found;
    wire [4:0] msb_position;
    reg [7:0] exponent;
    reg [22:0] mantissa;

    // Convert decimal to binary representation
    decimal_to_binary converter (
        .decimal_number(decimal),
        .binary_out(binary_representation)
    );

    // Find MSB position and normalize
    msb_finder_trimmed msb_finder (
        .data_in(binary_representation),
        .msb_position(msb_position),
        .trimmed_data(normalized_data),
        .found(found)
    );

    always @(*) begin
        if (!found) begin
            floatingpoint = 32'b0; // Return zero if no bits found
        end else begin
            exponent = msb_position + 127; // Bias exponent
            mantissa = normalized_data[30:8]; // Extract 23-bit mantissa
            floatingpoint = {1'b0, exponent, mantissa}; // Assemble IEEE 754 FP32
        end
    end
endmodule
