module mymod(A,B,S);
input wire [7:0] A;
input wire [7:0] B ;
output reg [7:0] S;
reg [7:0] g ;
reg e,f ;
always @(*)
  begin 
     g = A+B ;
   end
always @(*) begin
    e = A[7];
    f = B[7];
end
always @ (*) begin
    if (e==f) begin 
        if (g[7]==e)begin 
            S[7:0]=g[7:0];
        end
        else begin 
            S[7:0]=8'bxxxxxxxx;
            $display("overflow");
        end
    end
    else begin 
        S[7:0]=g[7:0];
    end
end
endmodule   