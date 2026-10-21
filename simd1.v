module simd_addsub (
    input  wire [127:0] A,
    input  wire [127:0] B,
    input  wire [1:0]   mode,
    input  wire         op,
    output reg  [127:0] Y
);
    wire [127:0] y8, y16, y32;

    // ---------------- 8-bit lanes (16) ----------------
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : L8
            wire [8:0] r = op ? ({1'b0, A[8*i +: 8]} - {1'b0, B[8*i +: 8]})
                              : ({1'b0, A[8*i +: 8]} + {1'b0, B[8*i +: 8]});
            // r[8]=1 : carry (add) -> 0xFF ; borrow (sub) -> 0x00
            assign y8[8*i +: 8] = r[8] ? (op ? 8'h00 : 8'hFF) : r[7:0];
        end
    // ---------------- 16-bit lanes (8) ----------------
        for (i = 0; i < 8; i = i + 1) begin : L16
            wire [16:0] r = op ? ({1'b0, A[16*i +: 16]} - {1'b0, B[16*i +: 16]})
                               : ({1'b0, A[16*i +: 16]} + {1'b0, B[16*i +: 16]});
            assign y16[16*i +: 16] = r[16] ? (op ? 16'h0000 : 16'hFFFF) : r[15:0];
        end
    // ---------------- 32-bit lanes (4) ----------------
        for (i = 0; i < 4; i = i + 1) begin : L32
            wire [32:0] r = op ? ({1'b0, A[32*i +: 32]} - {1'b0, B[32*i +: 32]})
                               : ({1'b0, A[32*i +: 32]} + {1'b0, B[32*i +: 32]});
            assign y32[32*i +: 32] = r[32] ? (op ? 32'h0 : 32'hFFFF_FFFF) : r[31:0];
        end
    endgenerate

    // Mode select (the control signal that picks the element width)
    always @(*) begin
        case (mode)
            2'b00:   Y = y8;
            2'b01:   Y = y16;
            2'b10:   Y = y32;
            default: Y = 128'h0;   // unsupported mode
        endcase
    end
endmodule
