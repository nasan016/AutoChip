`timescale 1ns / 1ps

// AutoChip-friendly testbench for an overlapping sequence detector.
// DUT interface assumed:
//   module fsm_overlap(input clk, input reset, input X, output Z);
// Pattern under test (MSB-first): 00011000

module tb;

  // DUT I/O
  reg  clk;
  reg  reset;   // active-high reset
  reg  X;       // serial input
  wire Z;       // detector output

  // Instantiate DUT (edit port names if different)
  fsm_overlap uut (
    .clk  (clk),
    .reset(reset),
    .X    (X),
    .Z    (Z)
  );

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Stats struct (SV; works with -g2012)
  typedef struct packed {
      int errors;
      int clocks;
  } stats_t;

  stats_t stats1;

  // Reference model (overlap allowed)
  parameter integer PLEN = 8;
  parameter [PLEN-1:0] PATTERN = 8'b00011000;

  reg [PLEN-1:0] hist; // sliding window of last PLEN bits
  reg refZ;

  // Drive a packed vector MSB-first for 'len' bits
  task run_sequence;
    input [255:0] seq;
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
      stats1.clocks++;
      if (Z !== refZ) stats1.errors++;
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
    stats1.errors = 0;
    stats1.clocks = 0;

    repeat (2) @(posedge clk);
    reset = 1'b0;  // deassert reset
    @(posedge clk);

    // Sequences to exercise overlap of 00011000 (MSB-first)
    run_sequence(32'b00000000_00011000, 32);                          // single hit at end
    run_sequence(32'b00011000_00011000, 32);                          // back-to-back hits
    run_sequence(40'b000000_0001100011000, 40);                       // overlapped hits
    run_sequence(64'b00011000_00000000_00011000_00011000, 64);        // multiple hits

    // Final summary (AutoChip-friendly)
    $display("Hint: Total mismatched samples is %0d out of %0d samples\n",
             stats1.errors, stats1.clocks);
    $display("Mismatches: %0d in %0d samples",
             stats1.errors, stats1.clocks);

    $finish;
  end

  // VCD
  initial begin
    $dumpfile("fsm_overlap_tb.vcd");
    $dumpvars(0, tb);
  end

endmodule

