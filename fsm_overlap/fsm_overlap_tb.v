`timescale 1ns / 1ps

// AutoChip-friendly testbench for OVERLAPPING detector of pattern 00011000 (MSB-first).

module tb;

  // DUT I/O
  reg  clk;
  reg  reset;   // active-high, synchronous
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
  always #5 clk = ~clk; // 10 ns period

  // Stats struct (SV; works with -g2012)
  typedef struct packed {
      int errors;
      int clocks;
  } stats_t;

  stats_t stats1;

  // Streams and expected Z masks for OVERLAP behavior
  //   8'b00011000                       -> 8'b00000001
  //  16'b0001100000011000               -> 16'b0000000100000001
  //  13'b0001100011000                  -> 13'b0000000100001      (overlap => 2 pulses)
  //  18'b000110001100011000             -> 18'b000000010000100001 (overlap => 3 pulses)

  // Reusable runner: drives one bit per cycle (MSB-first) and compares to expected mask.
  task run_test;
    input [63:0]  stream;   // left-aligned usage depends on 'length'
    input integer length;   // number of valid bits in 'stream'
    input [63:0]  expected; // expected Z mask, same length
    input [127:0] name;     // label
    integer j;
  begin
    for (j = length-1; j >= 0; j = j - 1) begin
      X = stream[j];
      #10; // one clock per bit

      // Count a sample and compare
      stats1.clocks++;
      if (Z !== expected[j]) begin
        stats1.errors++;
      end
    end
  end
  endtask

  // Test runner
  initial begin
    // init & reset
    reset = 1;
    X     = 0;
    stats1.errors = 0;
    stats1.clocks = 0;

    #20;        // hold reset a couple cycles
    reset = 0;  // deassert
    #10;

    run_test(  8'b00011000,                    8,  8'b00000001,                  "8b_one_hit");
    run_test( 16'b0001100000011000,           16, 16'b0000000100000001,         "16b_two_hits_separated");
    run_test( 13'b0001100011000,              13, 13'b0000000100001,            "13b_two_hits_overlap");
    run_test( 18'b000110001100011000,         18, 18'b000000010000100001,       "18b_three_hits_overlap");

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

