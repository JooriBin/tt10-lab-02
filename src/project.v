/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_project (
    input  wire [7:0] ui_in,   // 8-bit input A
    input  wire [7:0] uio_in,  // 8-bit input B
    output wire [7:0] uo_out,  // 8-bit output C
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

    assign uo_out = C;

endmodule
