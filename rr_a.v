module rr_a(
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] gnt
);
    reg [1:0] priority;
    // Combinational grant logic
    always @(*) begin
        gnt = 4'b0000;
        case (priority)
            2'd0: begin
                if (req[0]) gnt = 4'b0001;
                else if (req[1]) gnt = 4'b0010;
                else if (req[2]) gnt = 4'b0100;
                else if (req[3]) gnt = 4'b1000;
            end
            2'd1: begin
                if (req[1]) gnt = 4'b0010;
                else if (req[2]) gnt = 4'b0100;
                else if (req[3]) gnt = 4'b1000;
                else if (req[0]) gnt = 4'b0001;
            end
            2'd2: begin
                if (req[2]) gnt = 4'b0100;
                else if (req[3]) gnt = 4'b1000;
                else if (req[0]) gnt = 4'b0001;
                else if (req[1]) gnt = 4'b0010;
            end
            2'd3: begin
                if (req[3]) gnt = 4'b1000;
                else if (req[0]) gnt = 4'b0001;
                else if (req[1]) gnt = 4'b0010;
                else if (req[2]) gnt = 4'b0100;
            end
        endcase
    end
    // Sequential priority update
    always @(posedge clk or posedge rst) begin
        if (rst)
            priority <= 2'd0;
        else begin
            case (gnt)
                4'b0001: priority <= 2'd1;
                4'b0010: priority <= 2'd2;
                4'b0100: priority <= 2'd3;
                4'b1000: priority <= 2'd0;
                default: priority <= priority;
            endcase
        end
    end
endmodule
