/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_project (
    input  wire [7:0] ui_in,   // 8-bit input A
    input  wire [7:0] uio_in,  // 8-bit input B
    output reg  [7:0] uo_out,  // 8-bit output C
    output wire [7:0] uio_out, // Unused, set to 0
    output wire [7:0] uio_oe,  // Unused, set to 0
    input  wire       ena,     // Enable
    input  wire       clk,     // Clock
    input  wire       rst_n    // Active-low reset
);

    wire [15:0] In;   // Combined 16-bit input
    reg  [7:0]  C;    // Output priority encoder result

    assign In = {ui_in, uio_in}; // Merge A and B

    always @(*) begin
        if (ena) begin
            if      (In[15]) C = 8'd15;
            else if (In[14]) C = 8'd14;
            else if (In[13]) C = 8'd13;
            else if (In[12]) C = 8'd12;
            else if (In[11]) C = 8'd11;
            else if (In[10]) C = 8'd10;
            else if (In[9])  C = 8'd9;
            else if (In[8])  C = 8'd8;
            else if (In[7])  C = 8'd7;
            else if (In[6])  C = 8'd6;
            else if (In[5])  C = 8'd5;
            else if (In[4])  C = 8'd4;
            else if (In[3])  C = 8'd3;
            else if (In[2])  C = 8'd2;
            else if (In[1])  C = 8'd1;
            else if (In[0])  C = 8'd0;
            else             C = 8'hF0; // Special case: No '1' found
        end
        else begin
            C = 8'bzzzzzzzz; // Disabled state
        end
    end

    assign uo_out  = C;        // Priority Encoder Output
    assign uio_out = 0; // Not used, set to 0
    assign uio_oe  = 0; // Not used, set to 0

    // List unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
