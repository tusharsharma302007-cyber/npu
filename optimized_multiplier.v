module optimized_multiplier (
    input clk, rst,
    input [3:0] M, Q,
    output reg [7:0] P,
    output reg done
);
    reg [8:0] CAQ; // {C (1-bit), Register A (4-bit), Register Q (4-bit)}
    reg [2:0] count;
    wire [4:0] sum = CAQ[7:4] + M; // 5-bit result, keeps the carry
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            CAQ   <= {5'b00000, Q}; // C=0, A=0, Q=multiplier
            count <= 3'd0;
            P     <= 8'd0;
            done  <= 1'b0;
        end else if (count < 4) begin
            // 1. Adding M to A if low bit of Q (CAQ[0]) is 1, then right shifting full CAQ register
            if (CAQ[0]) 
                CAQ <= {1'b0, sum, CAQ[3:1]};
            else 
                CAQ <= {1'b0, CAQ[8:1]};
            count <= count + 1'b1;
            if (count == 3'd3) begin
                // Capturing final product output when 4 steps complete
                P    <= (CAQ[0]) ? {sum, CAQ[3:1]} : CAQ[8:1];
                done <= 1'b1;
            end
        end
    end
endmodule