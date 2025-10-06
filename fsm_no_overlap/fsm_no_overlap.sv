// You are writing a Verilog module named fsm_no_overlap that must pass a hidden AutoChip testbench.
// The module declaration is exactly:
//   module fsm_no_overlap (input wire clk, input wire reset, input wire X, output reg Z);
//
// Requirements:
// - reset is active-high and synchronous to clk.
// - Detect the serial bit sequence 00011000 (MSB-first) on input X.
// - Overlap is NOT allowed: after a detection, the FSM must restart so overlapping hits are suppressed.
// - Assert Z=1 for exactly one clock cycle when the final bit of the sequence is sampled (on posedge clk).
// - Otherwise Z=0.
// - Fully synthesizable RTL: single clocked always block for state/counter, clean next-state logic, no delays/latches.
// - Registered output Z on the rising edge of clk.
// here's the interface for the module:
module fsm_no_overlap (
    input wire clk,
    input wire reset,
    input wire X,
    output reg Z
);
