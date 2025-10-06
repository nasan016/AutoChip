// I am trying to create a Verilog model for a traffic light state machine. It must meet the following specifications:
//     - Inputs:
//         - Clock
//         - Active-low reset
//         - Enable
//     - Outputs:
//         - Red
//         - Yellow
//         - Green
// 
// The state machine should reset to a red light, change from red to green after 32 clock cycles, change from green to yellow after 20 clock cycles, and then change from yellow to red after 7 clock cycles.

module traffic_light_fsm (
    input  wire clk,        // Clock signal
    input  wire reset_n,    // Active-low reset
    input  wire enable,     // Enable signal
    output reg  red,        // Red light output
    output reg  yellow,     // Yellow light output
    output reg  green       // Green light output
);
