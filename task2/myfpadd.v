module addsmtg(A, B, S, B1, B2, clkk, overflow_flag);
    input [9:0] A;
    input [9:0] B;
    input clkk;
    input B1, B2;
    output reg [9:0] S;
    output reg overflow_flag;
    reg [10:0] sum_diff;
    always @(posedge clkk) begin
        if (B1 == B2) begin
            sum_diff = A + B;
            if (sum_diff[10]) begin
                S = 10'b1111111111;
            end else begin
                S = sum_diff[9:0];
            end
        end else begin
            if (A < B) begin
                S = B - A;
            end else begin
                S = A - B;
            end
        end
    end
    always @(posedge clkk) begin
        if ((B1 == 0 && B2 == 0 && S[9]) || (B1 == 1 && B2 == 1 && !S[9])) begin
            overflow_flag = 1;
        end else begin
            overflow_flag = 0;
        end
    end
endmodule
module fpadd(clk, rst, i_a, i_b, o_res, overflow);
    input clk, rst;
    input [15:0] i_a, i_b;
    output reg [15:0] o_res;
    output overflow;
    wire is_nan_a = (E1 == 5'b11111) && (M1 != 10'b0);
    wire is_nan_b = (E2 == 5'b11111) && (M2 != 10'b0);
    wire is_inf_a = (E1 == 5'b11111) && (M1 == 10'b0);
    wire is_inf_b = (E2 == 5'b11111) && (M2 == 10'b0);
    reg [4:0] E1, E2, E_res;
    reg [9:0] M1, M2;
    wire [9:0] MO;
    reg s1, s2, ss;
    addsmtg h1(
        .A(M1),
        .B(M2),
        .clkk(clk),
        .S(MO),
        .B1(s1),
        .B2(s2),
        .overflow_flag(overflow)
    );
    always @(*) begin
        E1 = i_a[15:11];
        E2 = i_b[15:11];
        M1 = i_a[10:1];
        M2 = i_b[10:1];
        s1 = i_a[0];
        s2 = i_b[0];
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ss <= 1'b0;
            o_res <= 16'b0;
        end else begin
            o_res <= {s1 ^ s2, E_res, MO};
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
always @(posedge clk or posedge rst) begin
    if (rst) begin
        o_res <= 16'b0;
    end else if (is_nan_a || is_nan_b) begin
        o_res <= {1'b0, 5'b11111, 10'b1111111111}; // NaN
    end else if (is_inf_a || is_inf_b) begin
        o_res <= {s1 ^ s2, 5'b11111, 10'b0}; // Infinity
    end else if (i_a == 16'b0 || i_b == 16'b0) begin
          o_res = (i_a == 16'b0) ? i_b : i_a;
    end
    else begin
        // Normal operations
        o_res <= {s1 ^ s2, E_res, MO};
    end
end
endmodule 