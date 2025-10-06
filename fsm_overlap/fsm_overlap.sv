// You are writing a Verilog module named fsm_overlap that must pass a hidden AutoChip testbench.
// The module declaration is exactly:
//   module fsm_overlap (input wire clk, input wire reset, input wire X, output reg Z);
//
// Requirements:
// - reset is active-high and synchronous to clk.
// - Detect the serial bit sequence 00011000 (MSB-first) on input X.
// - Overlap IS allowed (e.g., "...0001100011000..." contains two detections).
// - Assert Z=1 for exactly one clock cycle when the final bit of the sequence is sampled (on posedge clk).
// - Otherwise Z=0.
// - Fully synthesizable RTL: single clocked always block for state/counter, clean next-state logic, no delays/latches.
// - Registered output Z on the rising edge of clk.
// here's the interface for the module:
module fsm_overlap (
    input  wire clk,
    input  wire reset,
    input  wire X,
    output reg  Z
);
