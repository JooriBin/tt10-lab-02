`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file for waveform viewing
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Declare inputs as regs and outputs as wires
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;    // Input A
  reg [7:0] uio_in;   // Input B
  wire [7:0] uo_out;  // Output C
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate the Priority Encoder module
  tt_um_project uut (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in(ui_in),     // Connect input A
      .uio_in(uio_in),   // Connect input B
      .uo_out(uo_out),   // Connect output C
      .uio_out(uio_out), // Unused
      .uio_oe(uio_oe),   // Unused
      .ena(ena),         // Enable
      .clk(clk),         // Clock
      .rst_n(rst_n)      // Active-low reset
  );

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period -> 100MHz
  end

  // Reset Sequence
  initial begin
    ena = 1;
    ui_in = 8'b00000000;
    uio_in = 8'b00000000;
    rst_n = 0;
    #100; // Wait 100ns
    rst_n = 1;
  end

endmodule
