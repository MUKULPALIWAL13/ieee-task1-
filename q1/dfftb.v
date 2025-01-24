`timescale 1ns/1ps
module dfftestbench;
reg T,clk;
wire Q,SO;
tff t1(.T(T),.clk(clk),.Q(Q),.SO(SO));
initial 
 begin 
    clk = 0;
   forever #5 clk =  ~clk;
 end 
initial
 begin 
  $dumpfile("tff10.vcd");
  $dumpvars(0,dfftestbench);
  #2  T=0;
  #3  T =1;
  #5 T=0;
  #5 T=1;
  #5 T=0;
  #100 $finish;
 end
endmodule




