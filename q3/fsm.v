module fsm (
    input clk,
    input reset,
    input in,
    output reg out
);
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    
    reg [1:0] present_state, next_state;
    always @(*) begin
        case (present_state)
            A: begin
                if (in) next_state = B;
                else next_state = A;
                out = 0;
            end
            B: begin
                if (in) next_state = B;
                else next_state = C;
                out = 0;
            end
            C: begin
                if (in) next_state = D;
                else next_state = A;
                out = 0;
            end
            D: begin
                if (in) next_state = B;
                else next_state = C;
                out = 1;
            end
            default: begin
                next_state = A;
                out = 0;
            end
        endcase
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            present_state <= A;
        end else begin
            present_state <= next_state;
        end
    end
endmodule
