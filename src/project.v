/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_project (
    input  wire [7:0] ui_in,   // 8-bit input A
    output wire [7:0] uo_out,  // 8-bit output C
    input  wire [7:0] uio_in,  // 8-bit input B
    output wire [7:0] uio_out, // Unused, set to 0
    output wire [7:0] uio_oe,  // Unused, set to 0
    input  wire       ena,     // Enable
    input  wire       clk,     // Clock
    input  wire       rst_n    // Active-low reset
);

    reg [7:0] C;
    reg [15:0] In;  // Combined input A & B
    integer i;

    always @* begin
        In = {ui_in, uio_in};  // Merge A and B into a single 16-bit input
        C = 8'hF0; // Default case: No '1' found

        for (i = 15; i >= 0; i = i - 1) begin
            if (In[i]) begin
                C = i; // Output first detected '1' bit position
                break;
            end
        end
    end

    assign uo_out  = C;        // Priority Encoder Output
    assign uio_out = 8'b00000000; // Not used, set to 0
    assign uio_oe  = 8'b00000000; // Not used, set to 0

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
