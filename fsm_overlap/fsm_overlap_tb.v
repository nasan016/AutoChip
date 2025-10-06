`timescale 1ns / 1ps

// AutoChip-friendly testbench for an overlapping sequence detector.
// DUT interface assumed:
//   module fsm_overlap(input clk, input reset, input X, output Z);
// Pattern under test: 1011 (MSB-first)

module tb;

  // DUT I/O
  reg  clk;
  reg  reset;   // active-high reset
  reg  X;       // serial input
  wire Z;       // detector output

  // Instantiate DUT
  fsm_overlap uut (
    .clk  (clk),
    .reset(reset),
    .X    (X),
    .Z    (Z)
  );

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Stats
  integer errors;
  integer clocks;

  // Reference model (overlap allowed)
  parameter PLEN = 4;
  parameter [PLEN-1:0] PATTERN = 4'b1011;

  reg [PLEN-1:0] hist; // sliding window of last PLEN bits
  reg refZ;

  // Drive a packed vector MSB-first for 'len' bits
  task run_sequence;
    input [127:0] seq;
    input integer len;
    integer i;
  begin
    for (i = len-1; i >= 0; i = i - 1) begin
      X <= seq[i];
      @(posedge clk);

      // reference update (overlap via sliding window)
      hist <= {hist[PLEN-2:0], seq[i]};
      refZ <= (hist == PATTERN);

      @(negedge clk); // sample away from driving edge
      clocks = clocks + 1;
      if (Z !== refZ) errors = errors + 1;
    end
  end
  endtask

  // Test runner
  initial begin
    // init
    reset  = 1'b1;
    X      = 1'b0;
    hist   = {PLEN{1'b0}};
    refZ   = 1'b0;
    errors = 0;
    clocks = 0;

    repeat (2) @(posedge clk);
    reset = 1'b0;  // deassert reset
    @(posedge clk);

    // Sequences to exercise overlap of 1011
    run_sequence(128'b0000_0000_0000_0000_0000_0000_0000_1011, 16);
    run_sequence(128'b0000_0000_0000_0000_0000_0000_1011_0111, 16);
    run_sequence(128'b0000_0000_0000_0000_0000_1011_0101_10,   16);
    run_sequence(128'b0000_0000_0000_0000_1011_1011_1011_0000, 32);

    // Summary (AutoChip parses the last line)
    $display("Hint: Total mismatched samples is %0d out of %0d samples\n", errors, clocks);
    $display("Mismatches: %0d in %0d samples", errors, clocks);
    $finish;
  end

  // VCD
  initial begin
    $dumpfile("fsm_overlap_tb.vcd");
    $dumpvars(0, tb);
  end

endmodule

