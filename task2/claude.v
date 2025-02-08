module fpadd(
    input clk, 
    input rst,
    input [15:0] i_a, 
    input [15:0] i_b,
    output reg [15:0] o_res,
    output reg overflow
);
    // Special case detection
    wire is_max_exp_a = (i_a[14:10] == 5'b11111);
    wire is_max_exp_b = (i_b[14:10] == 5'b11111);
    wire is_zero_a = (i_a[14:0] == 15'b0);
    wire is_zero_b = (i_b[14:0] == 15'b0);

    // Extended precision computation
    reg [11:0] mantissa_a, mantissa_b;
    reg [4:0] exp_a, exp_b, aligned_exp;
    reg sign_a, sign_b, result_sign;
    reg [12:0] aligned_mantissa;

    // Preprocessing and alignment
    always @(*) begin
        exp_a = i_a[14:10];
        exp_b = i_b[14:10];
        sign_a = i_a[15];
        sign_b = i_b[15];
        
        mantissa_a = {2'b01, i_a[9:0]};
        mantissa_b = {2'b01, i_b[9:0]};

        // Maximum exponent special handling
        if (is_max_exp_a && is_max_exp_b) begin
            aligned_exp = 5'b11111;
            aligned_mantissa = 13'b1111111111111;
            result_sign = sign_a;
        end else if (exp_a > exp_b) begin
            aligned_exp = exp_a;
            aligned_mantissa = {1'b0, mantissa_a} + ({1'b0, mantissa_b} >> (exp_a - exp_b));
        end else begin
            aligned_exp = exp_b;
            aligned_mantissa = {1'b0, mantissa_b} + ({1'b0, mantissa_a} >> (exp_b - exp_a));
        end

        // Sign determination
        result_sign = (is_max_exp_a || is_max_exp_b) ? sign_a : 
                      (mantissa_a > mantissa_b) ? sign_a : sign_b;
    end

    // Output generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_res <= 16'b0;
            overflow <= 1'b0;
        end else begin
            // Zero input handling
            if (is_zero_a) begin
                o_res <= i_b;
                overflow <= 1'b0;
            end else if (is_zero_b) begin
                o_res <= i_a;
                overflow <= 1'b0;
            end
            // Maximum exponent special cases
            else if (is_max_exp_a || is_max_exp_b) begin
                o_res <= {result_sign, 5'b11111, 10'b1111111111};
                overflow <= 1'b1;
            end
            // Normal computation
            else begin
                // Normalization
                if (aligned_mantissa[12]) begin
                    aligned_exp = aligned_exp + 1;
                    aligned_mantissa = aligned_mantissa >> 1;
                end

                // Overflow check
                overflow <= (aligned_exp == 5'b11111);

                // Final result
                o_res <= {result_sign, 
                          overflow ? 5'b11111 : aligned_exp, 
                          aligned_mantissa[10:1]};
            end
        end
    end
endmodule