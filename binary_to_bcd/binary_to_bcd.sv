// I am trying to create a verilog modolue binary_to_bcd for a binary to binary-coded-decimal converter. It must meet as follows:
// - Inputs:
//     - Binary input (5-bits)
// - Outputs:
//     - BCD (8-bits: 4-bits for the 10s place and 4-bits for the 1s place)
// The following is the module template:

module binary_to_bcd_converter (
    input [4:0] binary_input;
    output reg [7:0] bcd_output;
);
