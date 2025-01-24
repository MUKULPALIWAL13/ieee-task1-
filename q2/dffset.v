module testfile (
    input wire D,     
    input wire clk,   
    input wire clear, 
    output reg Q     
);
    initial begin
        Q = 0; // Set initial value of Q
    end

    always @(posedge clk or posedge clear) begin
        if (clear)
            Q <= 1'b0;  
        else
            Q <= D;    
    end
endmodule

module dffset(
    input wire D,
    input wire clk,
    input wire set,
    output reg Q
);
    wire f;

    // Instantiate the testfile submodule
    testfile t5 (
        .D(D),
        .clk(clk),
        .clear(1'b0), // Hardwired clear to 0
        .Q(f)
    );

   
    always @(posedge clk or posedge set) 
      begin
        if (set) 
            Q <= 1'b1;
        else 
            Q <= f;    
      end
endmodule
