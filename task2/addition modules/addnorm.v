// Normalization Module
module normalization(clk, rst, mantissa, exponent, norm_mantissa, norm_exponent);
    input clk, rst;
    input [10:0] mantissa;        
    input [4:0] exponent;          
    output reg [9:0] norm_mantissa;
    output reg [4:0] norm_exponent; 

    reg [10:0] intermanstissa; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            norm_mantissa <= 10'b0;
            norm_exponent <= 5'b0;
        end else begin
            intermanstissa <= mantissa; 
            norm_exponent <= exponent;

            if (intermanstissa == 11'b00000000000) begin
                norm_mantissa <= 10'b0000000000;
                norm_exponent <= 5'b00000;
            end else begin
                // Right-shift normalization
                while (intermanstissa[10] == 0 && norm_exponent > 0) begin
                    intermanstissa <= intermanstissa << 1;
                    norm_exponent <= norm_exponent - 1;
                end
                norm_mantissa <= intermanstissa[9:0];
            end
        end
    end
endmodule

// Adder/Subtractor Module (Adds or Subtracts the mantissas)
module addsmtg(A, B, S, B1, B2, E_res, clkk, E_new,so);
    input [10:0] A;
    input [10:0] B;
    input [4:0] E_res;
    input clkk;
    input B1, B2;
    output reg [10:0] S;
    output reg [4:0] E_new;
    output reg so;

    reg [11:0] sum_diff; 

    always @(posedge clkk) begin
        E_new <= E_res;
        if (B1 == B2) begin
            sum_diff = A + B;
            if (sum_diff[11]) begin
                sum_diff <= sum_diff >> 1; 
                E_new <= E_new + 1;        
            end
            S <= sum_diff[10:0];          
        end else begin
            if ((B1 == 1 && B2 == 0) && B>=A) begin
                S <= B - A;
                so <= 0;
            end
            else if ((B1 == 1 && B2 == 0) && B<A) begin
                S <= B - A;
                so <= 1;
            end
            else if ((B1 == 0 && B2 == 1) && B>A) begin
                S <= A - B;
                so <= 1;
            end else if ((B1 == 0 && B2 == 1) && B<=A) begin
                S <= A - B;
                so <= 0;
            end
        end
    end
endmodule

// Main FP Adder/Subtractor Module
module fpadd(clk, rst, i_a, i_b, o_res, overflow);
    input clk, rst;
    input [15:0] i_a, i_b;
    output reg [15:0] o_res;
    output reg overflow;

    reg [4:0] E1, E2, E_res;
    reg [10:0] M1, M2;
    wire [10:0] MO;
    wire [9:0] norm_mantissa;
    wire [4:0] norm_exponent;
    wire [4:0] E_new;
    reg s1, s2;
    wire so;

    // Extract fields from inputs
    always @(*) begin
        E1 = i_a[14:10];
        E2 = i_b[14:10];
        M1 = {1'b1, i_a[9:0]}; 
        M2 = {1'b1, i_b[9:0]};
        s1 = i_a[15];
        s2 = i_b[15];
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_res <= 16'b0;
        end else begin
            if (E1 > E2) begin
                M2 <= M2 >> (E1 - E2);
                E_res <= E1;
            end else if (E2 > E1) begin
                M1 <= M1 >> (E2 - E1);
                E_res <= E2;
            end else begin
                E_res <= E1;
            end
        end
    end

    addsmtg h1(
        .A(M1),
        .B(M2),
        .clkk(clk),
        .E_res(E_res),
        .S(MO),
        .B1(s1),
        .B2(s2),
        .so(so),
        .E_new(E_new)
    );

    normalization norm(
        .clk(clk),
        .rst(rst),
        .mantissa(MO),
        .exponent(E_new),
        .norm_mantissa(norm_mantissa),
        .norm_exponent(norm_exponent)
    );

    // Special cases: NaN and Infinity detection
    wire is_nan_a = (E1 == 5'b11111) && (M1[9:0] != 0);
    wire is_nan_b = (E2 == 5'b11111) && (M2[9:0] != 0);
    wire is_inf_a = (E1 == 5'b11111) && (M1[9:0] == 0);
    wire is_inf_b = (E2 == 5'b11111) && (M2[9:0] == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_res <= 16'b0;
            overflow <= 1'b0;
        end else begin
            // Handle special cases
            if (is_nan_a || is_nan_b) begin
                o_res <= {1'b0, 5'b11111, 10'b1111111111}; 
                overflow <= 1'b1;
            end else if (is_inf_a || is_inf_b) begin
                o_res <= {s1 ^ s2, 5'b11111, 10'b0};  
                overflow <= 1'b1;
            end else if (i_a[14:0] == 0 || i_b[14:0] == 0) begin
                o_res <= (i_a[14:0] == 0) ? i_b : i_a; 
                overflow <= 1'b0;
            end else begin
                o_res <= {so, norm_exponent, norm_mantissa};
                overflow <= 1'b0;
            end
        end
    end
endmodule
