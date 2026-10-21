`timescale 1ns/1ps

module tb_optimized_multiplier;
    reg        clk, rst;
    reg  [3:0] M, Q;
    wire [7:0] P;
    wire       done;

    optimized_multiplier dut (.clk(clk), .rst(rst), .M(M), .Q(Q), .P(P), .done(done));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("opt_mult.vcd");
        $dumpvars(0, tb_optimized_multiplier);

        // Test 1: 3 x 5 = 15
        M = 4'd3; Q = 4'd5;
        rst = 1; #12; rst = 0;
        #60;

        // Test 2: 7 x 9 = 63
        M = 4'd7; Q = 4'd9;
        rst = 1; #12; rst = 0;
        #60;

        // Test 3: 15 x 15 = 225
        M = 4'd15; Q = 4'd15;
        rst = 1; #12; rst = 0;
        #60;

        $finish;
    end
endmodule