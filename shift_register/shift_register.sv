// I am trying to create a Verilog model for a shift register. It must meet the following specifications:
// 	- Inputs:
// 		- Clock
// 		- Active-low reset
// 		- Data (1 bit)
// 		- Shift enable
// 	- Outputs:
// 		- Data (8 bits) 
module top_module (
  input wire clk,        // Clock signal
  input wire reset_n,    // Active-low reset signal
  input wire data_in,    // Data input
  input wire shift_enable,
  output reg [7:0] data_out
);
