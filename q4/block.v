module block_assgn(
    input [8:0] a, b,      
    input clk,             
    output reg [8:0] sw_a, sw_b 
);
    reg [8:0] ta, tb;  

    always @(posedge clk) begin
        
        ta = a;  
        tb = b;  
        sw_a = tb;  
        sw_b = ta; 
    end
endmodule

module nonblock_assgn(c,d,clk,sw_c,sw_d);
 input [7:0] c,d ;
 input clk;
 output reg[7:0] sw_c,sw_d ;
 always @(posedge clk)
 begin 
   sw_c<=d;
   sw_d<=c;
 end
endmodule

module nonblock_assgn1(
    input [7:0] c, d,       
    input clk,               
    output reg [7:0] sw_c,  
    output reg [7:0] sw_d
);

    always @(posedge clk) 
    begin
        sw_d <= c ^ d;       
        sw_c <= c ^ sw_d;    
        sw_d <= sw_d ^ sw_c; 
    end
endmodule