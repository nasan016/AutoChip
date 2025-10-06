`timescale 1ns / 1ps

// module tb_binary_to_bcd_converter;
module tb;

reg [4:0] binary_input;
wire [7:0] bcd_output;

binary_to_bcd_converter uut (
    .binary_input(binary_input),
    .bcd_output(bcd_output)
);

integer i;
reg [4:0] test_binary;
reg [7:0] expected_bcd;

typedef struct packed {
    int errors;
    int errortime;
    int errors_p1y;
    int errortime_p1y;
    int errors_p2y;
    int errortime_p2y;
    int clocks;
} stats;

stats stats1;

initial begin
    $display("Testing Binary-to-BCD Converter...");

    for (i = 0; i < 32; i++) begin
        stats1.clocks++;
        test_binary = i;
        binary_input = test_binary;

        // Calculate expected BCD output
        expected_bcd[3:0] = test_binary % 10;
        expected_bcd[7:4] = test_binary / 10;

        #10; // Wait for the results

        if (bcd_output !== expected_bcd) begin
            stats1.errors++;
            // $display("Error: Test case %0d failed. Expected BCD: 8'b%0b, Got: 8'b%0b",
            // test_binary, expected_bcd, bcd_output);
            // $finish;
        end
    end

    $display("Hint: Total mismatched samples is %1d out of %1d samples\n", stats1.errors, stats1.clocks);
    $display("Mismatches: %1d in %1d samples", stats1.errors, stats1.clocks);
    $finish;
    // $display("All test cases passed!");
    // $finish;
end

reg vcd_clk;

initial begin
    $dumpfile("my_design.vcd");
    // $dumpvars(0, tb_binary_to_bcd_converter);
    $dumpvars(0, tb);
end

always #5 vcd_clk = ~vcd_clk; // Toggle clock every 5 time units

endmodule

