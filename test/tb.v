`timescale 1ns / 1ps

module tt_um_tb;
    reg clk;
    reg [15:0] ui_in;
    wire [7:0] uo_out;

    // Instantiate the priority encoder module
    tt_um_example dut (
        .clk(clk),
        .ui_in(ui_in),
        .uo_out(uo_out)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        clk = 0;

        // Test Priority Encoder
        #10 ui_in = 16'b0010101011110001; // Expect C = 00001011
        #10 ui_in = 16'b0000000000000001; // Expect C = 00000000
        #10 ui_in = 16'b0000000000000000; // Expect C = 11110000

        #10 $finish;
    end
endmodule
`timescale 1ns / 1ps

module tb;
    reg clk;
    reg [15:0] ui_in;
    wire [7:0] uo_out;

    // Instantiate the priority encoder module
    tt_um_example dut (
        .clk(clk),
        .ui_in(ui_in),
        .uo_out(uo_out)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        clk = 0;

        // Test Priority Encoder
        #10 ui_in = 16'b0010101011110001; // Expect C = 00001011
        #10 ui_in = 16'b0000000000000001; // Expect C = 00000000
        #10 ui_in = 16'b0000000000000000; // Expect C = 11110000

        #10 $finish;
    end
endmodule
