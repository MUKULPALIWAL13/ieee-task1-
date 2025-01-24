module mux(input A, B, sel, output O);
    assign O = (sel) ? B : A; 
endmodule

module tff(T,clk,Q,SO);
 input T ,clk;
 output reg Q = 1'b1;
 output SO;//SO IS CORRECT OUTPUT
 mux g3(Q,~Q,T,SO);
 always @(posedge clk)
 begin
    Q<=SO;
 end
endmodule 
