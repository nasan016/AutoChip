// You are writing a Verilog module named fsm_no_overlap that must pass a hidden testbench.
//
// Interface (EXACTLY this):
//   module fsm_no_overlap (input  wire clk, input  wire reset, input  wire X, output reg Z);
//
// Target pattern and timing:
// - Detect the serial bit sequence 00011000 on X, MSB-first.
// - Non-overlapping detector: after a detection, the FSM must restart progress so overlapping hits are NOT counted.
// - Z must pulse HIGH for exactly one clock cycle when the final bit is accepted (registered on posedge clk).
//
// Reset and coding style:
// - reset is ACTIVE-HIGH and SYNCHRONOUS.
// - On reset: state <= S0; Z <= 0.
// - Use synthesizable RTL only. One clocked always block for the state/Z registers, and one combinational always block for next-state logic.
// - DO NOT use SystemVerilog enums/typedefs that cause “explicit cast” errors in iverilog. Instead, use localparam integer encodings for states.
// - Use nonblocking assignments (<=) in sequential logic and blocking (=) in combinational logic.
// - Do NOT write any testbench; only provide the fsm_no_overlap module.
//
// States and transitions (nine states S0..S8 follow your report):
// - Z = 1 ONLY when in state S8.
// - S0: X=0 -> S1; X=1 -> S0
// - S1: X=0 -> S2; X=1 -> S0
// - S2: X=0 -> S3; X=1 -> S0
// - S3: X=0 -> S3; X=1 -> S4
// - S4: X=0 -> S1; X=1 -> S5
// - S5: X=0 -> S6; X=1 -> S0
// - S6: X=0 -> S7; X=1 -> S0
// - S7: X=0 -> S8; X=1 -> S0
// - S8: Z=1; on X=0 -> S1 (zero can begin a new, NON-overlapping attempt); on X=1 -> S0
//
// Examples the design must satisfy:
// - 00011000                -> one Z=1 pulse
// - 0001100011000           -> one Z=1 pulse (second occurrence overlaps the first, so NOT counted)
// - 0001100000011000        -> two Z=1 pulses (two separated matches)
//
// Output:
// - Return ONLY the complete Verilog module for fsm_no_overlap with the interface above and the specified behavior.
// here's the interface for the module:
module fsm_no_overlap (
    input wire clk,
    input wire reset,
    input wire X,
    output reg Z
);
