module myshiftreg(clk,clr,load,data,ena,A,Q,E);
 input clk,clr,A,ena,load;
 input wire [3:0] data ;
 output reg [3:0] Q;
 output reg E ;
 reg B,C,D;
 always @(posedge clk or posedge clr)
 begin 
    if(clr) begin
      Q[3:0] <= 4'b0000;
      B<=0;
      C<=0;
      D<=0;
      E<=0;
    end
    else if(load) begin 
     Q[3:0]<=data[3:0];
    end
    else if(ena) begin
     E=D;
     D=C;
     C=B;
     B=A;
    end
 end
 always @(*)
 begin 
    Q[3]=E;
    Q[2]=D;
    Q[1]=C;
    Q[0]=B;
 end 
endmodule 
      