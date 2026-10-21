`timescale 1ns/1ps
module tb_simd_addsub;
    reg [127:0] A, B, expected;
    reg [1:0] mode; // 0 = 8-bit, 1 = 16-bit, 2 = 32-bit
    reg op; // 0 = add,   1 = sub
    wire [127:0] Y;
    integer errors;
    simd_addsub dut (.A(A), .B(B), .mode(mode), .op(op), .Y(Y));
    wire pass = (Y === expected); // goes high in the waveform when output is correct , using case equality
    initial begin
        $dumpfile("simd.vcd");
        $dumpvars(0, tb_simd_addsub);
        errors = 0;
        // ---- Test 1: 8-bit normal add ----
        mode = 2'd0; op = 1'b0;
        A = {8'd160, 8'd150, 8'd140, 8'd130, 8'd120, 8'd110, 8'd100, 8'd90, 8'd80, 8'd70, 8'd60, 8'd50, 8'd40, 8'd30, 8'd20, 8'd10};
        B = {8'd48, 8'd45, 8'd42, 8'd39, 8'd36, 8'd33, 8'd30, 8'd27, 8'd24, 8'd21, 8'd18, 8'd15, 8'd12, 8'd9, 8'd6, 8'd3};
        expected = {8'd208, 8'd195, 8'd182, 8'd169, 8'd156, 8'd143, 8'd130, 8'd117, 8'd104, 8'd91, 8'd78, 8'd65, 8'd52, 8'd39, 8'd26, 8'd13};
        #10;
        if (Y === expected) $display("Test  1 (8-bit normal add): PASS");
        else begin $display("Test  1 (8-bit normal add): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 2: 8-bit normal sub ----
        mode = 2'd0; op = 1'b1;
        A = {8'd160, 8'd150, 8'd140, 8'd130, 8'd120, 8'd110, 8'd100, 8'd90, 8'd80, 8'd70, 8'd60, 8'd50, 8'd40, 8'd30, 8'd20, 8'd10};
        B = {8'd48, 8'd45, 8'd42, 8'd39, 8'd36, 8'd33, 8'd30, 8'd27, 8'd24, 8'd21, 8'd18, 8'd15, 8'd12, 8'd9, 8'd6, 8'd3};
        expected = {8'd112, 8'd105, 8'd98, 8'd91, 8'd84, 8'd77, 8'd70, 8'd63, 8'd56, 8'd49, 8'd42, 8'd35, 8'd28, 8'd21, 8'd14, 8'd7};
        #10;
        if (Y === expected) $display("Test  2 (8-bit normal sub): PASS");
        else begin $display("Test  2 (8-bit normal sub): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 3: 8-bit saturating add ----
        mode = 2'd0; op = 1'b0;
        A = {8'd240, 8'd241, 8'd242, 8'd243, 8'd244, 8'd245, 8'd246, 8'd247, 8'd248, 8'd249, 8'd250, 8'd251, 8'd252, 8'd253, 8'd254, 8'd255};
        B = {8'd25, 8'd24, 8'd23, 8'd22, 8'd21, 8'd20, 8'd19, 8'd18, 8'd17, 8'd16, 8'd15, 8'd14, 8'd13, 8'd12, 8'd11, 8'd10};
        expected = {8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255, 8'd255};
        #10;
        if (Y === expected) $display("Test  3 (8-bit saturating add): PASS");
        else begin $display("Test  3 (8-bit saturating add): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 4: 8-bit saturating sub ----
        mode = 2'd0; op = 1'b1;
        A = {8'd20, 8'd19, 8'd18, 8'd17, 8'd16, 8'd15, 8'd14, 8'd13, 8'd12, 8'd11, 8'd10, 8'd9, 8'd8, 8'd7, 8'd6, 8'd5};
        B = {8'd45, 8'd43, 8'd41, 8'd39, 8'd37, 8'd35, 8'd33, 8'd31, 8'd29, 8'd27, 8'd25, 8'd23, 8'd21, 8'd19, 8'd17, 8'd15};
        expected = {8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
        #10;
        if (Y === expected) $display("Test  4 (8-bit saturating sub): PASS");
        else begin $display("Test  4 (8-bit saturating sub): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 5: 16-bit normal add ----
        mode = 2'd1; op = 1'b0;
        A = {16'd8000, 16'd7000, 16'd6000, 16'd5000, 16'd4000, 16'd3000, 16'd2000, 16'd1000};
        B = {16'd2400, 16'd2100, 16'd1800, 16'd1500, 16'd1200, 16'd900, 16'd600, 16'd300};
        expected = {16'd10400, 16'd9100, 16'd7800, 16'd6500, 16'd5200, 16'd3900, 16'd2600, 16'd1300};
        #10;
        if (Y === expected) $display("Test  5 (16-bit normal add): PASS");
        else begin $display("Test  5 (16-bit normal add): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 6: 16-bit normal sub ----
        mode = 2'd1; op = 1'b1;
        A = {16'd8000, 16'd7000, 16'd6000, 16'd5000, 16'd4000, 16'd3000, 16'd2000, 16'd1000};
        B = {16'd2400, 16'd2100, 16'd1800, 16'd1500, 16'd1200, 16'd900, 16'd600, 16'd300};
        expected = {16'd5600, 16'd4900, 16'd4200, 16'd3500, 16'd2800, 16'd2100, 16'd1400, 16'd700};
        #10;
        if (Y === expected) $display("Test  6 (16-bit normal sub): PASS");
        else begin $display("Test  6 (16-bit normal sub): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 7: 16-bit saturating add ----
        mode = 2'd1; op = 1'b0;
        A = {16'd65528, 16'd65529, 16'd65530, 16'd65531, 16'd65532, 16'd65533, 16'd65534, 16'd65535};
        B = {16'd17, 16'd16, 16'd15, 16'd14, 16'd13, 16'd12, 16'd11, 16'd10};
        expected = {16'd65535, 16'd65535, 16'd65535, 16'd65535, 16'd65535, 16'd65535, 16'd65535, 16'd65535};
        #10;
        if (Y === expected) $display("Test  7 (16-bit saturating add): PASS");
        else begin $display("Test  7 (16-bit saturating add): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 8: 16-bit saturating sub ----
        mode = 2'd1; op = 1'b1;
        A = {16'd12, 16'd11, 16'd10, 16'd9, 16'd8, 16'd7, 16'd6, 16'd5};
        B = {16'd29, 16'd27, 16'd25, 16'd23, 16'd21, 16'd19, 16'd17, 16'd15};
        expected = {16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
        #10;
        if (Y === expected) $display("Test  8 (16-bit saturating sub): PASS");
        else begin $display("Test  8 (16-bit saturating sub): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 9: 32-bit normal add ----
        mode = 2'd2; op = 1'b0;
        A = {32'd40000000, 32'd30000000, 32'd20000000, 32'd10000000};
        B = {32'd12000000, 32'd9000000, 32'd6000000, 32'd3000000};
        expected = {32'd52000000, 32'd39000000, 32'd26000000, 32'd13000000};
        #10;
        if (Y === expected) $display("Test  9 (32-bit normal add): PASS");
        else begin $display("Test  9 (32-bit normal add): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 10: 32-bit normal sub ----
        mode = 2'd2; op = 1'b1;
        A = {32'd40000000, 32'd30000000, 32'd20000000, 32'd10000000};
        B = {32'd12000000, 32'd9000000, 32'd6000000, 32'd3000000};
        expected = {32'd28000000, 32'd21000000, 32'd14000000, 32'd7000000};
        #10;
        if (Y === expected) $display("Test 10 (32-bit normal sub): PASS");
        else begin $display("Test 10 (32-bit normal sub): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 11: 32-bit saturating add ----
        mode = 2'd2; op = 1'b0;
        A = {32'd4294967292, 32'd4294967293, 32'd4294967294, 32'd4294967295};
        B = {32'd13, 32'd12, 32'd11, 32'd10};
        expected = {32'd4294967295, 32'd4294967295, 32'd4294967295, 32'd4294967295};
        #10;
        if (Y === expected) $display("Test 11 (32-bit saturating add): PASS");
        else begin $display("Test 11 (32-bit saturating add): FAIL"); errors = errors + 1; end
        #10;
        // ---- Test 12: 32-bit saturating sub ----
        mode = 2'd2; op = 1'b1;
        A = {32'd8, 32'd7, 32'd6, 32'd5};
        B = {32'd21, 32'd19, 32'd17, 32'd15};
        expected = {32'd0, 32'd0, 32'd0, 32'd0};
        #10;
        if (Y === expected) $display("Test 12 (32-bit saturating sub): PASS");
        else begin $display("Test 12 (32-bit saturating sub): FAIL"); errors = errors + 1; end
        #10;
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TESTS FAILED", errors);
        $finish;
    end
endmodule