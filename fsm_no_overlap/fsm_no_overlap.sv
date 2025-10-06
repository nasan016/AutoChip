// You are writing a Verilog module named fsm_no_overlap that must pass a hidden testbench.
// Interface (exactly this):
//   module fsm_no_overlap(input wire clk, input wire reset, input wire X, output reg Z);
// Requirements:
// - reset is active-high and synchronous to clk.
// - Detect the serial bit pattern 1011 (MSB-first) on input X.
// - Overlap is NOT allowed: after a detection, the FSM must restart so back-to-back overlapping hits do not occur.
// - Assert Z=1 for exactly one clock cycle when the final bit of the pattern is sampled.
// - Otherwise Z=0.
// - Fully synthesizable RTL: no delays, no latches.
// - Use a registered output Z driven on posedge clk.
// - Keep state and next-state logic clean (parameters for encodings are OK).
// here's the interface for the module:
module fsm_no_overlap (
    input wire clk,
    input wire reset,
    input wire X,
    output reg Z
);
