`timescale 1ns / 1ps
module tb_rr_a;
    reg clk, rst;
    reg [3:0] req;
    wire [3:0] gnt;
    integer i;
    // Instantiate the Unit Under Test (UUT)
    rr_a uut (
        .clk(clk),
        .rst(rst),
        .req(req),
        .gnt(gnt)
    );
    // Clock generation (10ns period)
    always #5 clk = ~clk;
    initial begin
        // Enable waveform dumping
        $dumpfile("rra.vcd");
        $dumpvars(0, tb_rr_a);
        clk = 0;
        rst = 1;
        req = 4'b0000;
        #10;
        rst = 0;
        $display("--- Testing Request Combinations ---");
        // Test all 16 request combinations
        for (i = 0; i < 16; i = i + 1) begin
            #10;
            req = i;
            #1;
            $display("Time=%0t | req=%b, gnt=%b", $time, req, gnt);
        end
        $display("--- Testing Round-Robin Priority Cycling ---");
        // Test Round-Robin fairness with all requests active
        req = 4'b1111;
        for (i = 0; i < 12; i = i + 1) begin
            #10;
            $display("Time=%0t | req=%b, gnt=%b", $time, req, gnt);
        end
        #20;
        $display("Simulation over! Waveforms dumped to rra.vcd");
        $finish;
    end
endmodule