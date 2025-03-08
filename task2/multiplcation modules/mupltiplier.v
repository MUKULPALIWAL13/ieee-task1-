module multiplier12(
    input clk, 
    input rst, 
    input [15:0] i_a, 
    input [15:0] i_b, 
    output reg [15:0] o_res,  // Changed from 17 to 22 bits
    output reg o_res_vld,
    output reg overflow,
    output reg underflow,
    output reg exception
);
    wire s1, s2, so;
    wire [4:0] E1, E2, EO;
    wire [9:0] M1, M2;
    wire [19:0] MO;  // Mantissa multiplication now produces a 20-bit result
    wire [9:0] Mf;
    wire [4:0] Ef;

    assign s1 = i_a[15];
    assign s2 = i_b[15];
    assign so = s1 ^ s2;  // Output sign

    assign E1 = i_a[14:10];
    assign E2 = i_b[14:10];
    assign M1 = {1'b1, i_a[9:0]};  // Normalized mantissa (implicit 1)
    assign M2 = {1'b1, i_b[9:0]};  

    assign MO = M1 * M2;  // 10-bit * 10-bit = 20-bit result
    assign EO = E1 + E2 - 5'b01111;  // Exponent calculation
    normalization n1 (.clk(clk),.rst(rst),.mantissa(MO[19:0]),.exponent(EO),.norm_mantissa(Mf),.norm_exponent(Ef));
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_res <= 0;
            o_res_vld <= 0;
            overflow <= 0;
            underflow <= 0;
            exception <= 0;
        end else begin
            // Handling overflow and underflow
            if (EO > 5'b11110) begin
                overflow <= 1;
                o_res <= 0;
                exception <= 1;
            end else if (EO < 5'b00001) begin
                underflow <= 1;
                o_res <= 0;
            end else begin
                overflow <= 0;
                underflow <= 0;
                exception <= 0;  // Store sign, exponent, and mantissa
                o_res_vld <= 1;
                o_res  = {so,Ef,Mf};
            end
        end
    end
endmodule
module normalization(
    input clk, rst,
    input [19:0] mantissa,        
    input [4:0] exponent,          
    output reg [9:0] norm_mantissa,
    output reg [4:0] norm_exponent
);

    reg [19:0] intermantissa; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            norm_mantissa <= 10'b0;
            norm_exponent <= 5'b0;
        end else begin
            intermantissa = mantissa; 
            norm_exponent = exponent;

            // Check for zero mantissa (special case)
            if (intermantissa == 20'b00000000000000000000) begin
                norm_mantissa <= 10'b0000000000;
                norm_exponent <= 5'b00000;
            end else begin
                // If the highest bit is 1, store the top 10 bits
                if (intermantissa[19]) begin
                    norm_mantissa <= intermantissa[19:10]; // Take top 10 bits
                    norm_exponent <= exponent + 1;        // Adjust exponent
                end else begin
                    // Normalize by left-shifting until MSB is 1
                    while (intermantissa[19] == 0 && norm_exponent > 0) begin
                        intermantissa = intermantissa << 1;
                        norm_exponent = norm_exponent - 1;
                    end
                    norm_mantissa <= intermantissa[19:10];  // Store normalized 10-bit mantissa
                end
            end
        end
    end
endmodule
