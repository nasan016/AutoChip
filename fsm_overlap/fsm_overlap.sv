// You are writing a Verilog module named fsm_overlap that must pass a hidden testbench.
//
// Interface (EXACTLY this):
//   module fsm_overlap (input  wire clk, input  wire reset, input  wire X, output reg Z);
//
// Target pattern and timing:
// - Detect the serial bit sequence 00011000 on X, MSB-first.
// - Overlapping detector: preserve partial progress so matches can start inside previous matches.
// - Z must pulse HIGH for exactly one clock cycle when the final bit is accepted (registered on posedge clk).
//
// Reset and coding style:
// - reset is ACTIVE-HIGH and SYNCHRONOUS.
// - On reset: state <= S0; Z <= 0.
// - Use synthesizable RTL only. One clocked always block for state/Z registers, and one combinational always block for next-state logic.
// - DO NOT use SystemVerilog enums/typedefs that cause “explicit cast” errors in iverilog. Instead, use localparam integer encodings for states.
// - Use nonblocking assignments (<=) in sequential logic and blocking (=) in combinational logic.
// - Do NOT write any testbench; only provide the fsm_overlap module.
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
// - S8: Z=1; on X=0 -> S3 (preserve suffix “000”); on X=1 -> S4 (preserve suffix “0001”)
//   (These S8 fallbacks enable overlaps exactly as in your diagram/table.)
//
// Examples the design must satisfy:
// - 00011000                -> one Z=1 pulse
// - 0001100011000           -> two Z=1 pulses (overlap allowed and counted)
// - 0001100000011000        -> two Z=1 pulses (two matches)
//
// Output:
// - Return ONLY the complete Verilog module for fsm_overlap with the interface above and the specified behavior.
// here's the interface for the module:
module fsm_overlap (
    input  wire clk,
    input  wire reset,
    input  wire X,
    output reg  Z
);
