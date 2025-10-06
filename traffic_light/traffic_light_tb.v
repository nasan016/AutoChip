`timescale 1ns / 1ps

module tb;

    // DUT I/O
    reg clk;
    reg reset_n;
    reg enable;
    wire red;
    wire yellow;
    wire green;

    // Stats struct
    typedef struct packed {
        int errors;
        int clocks;
    } stats;

    stats stats1;

    // Instantiate DUT
    traffic_light_fsm uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock (10 ns period)

    // Task: check expected output (no print per case)
    task check_output;
        input integer cycle;
        input logic exp_red;
        input logic exp_yellow;
        input logic exp_green;
    begin
        stats1.clocks++;
        @(negedge clk);
        if (red !== exp_red || yellow !== exp_yellow || green !== exp_green)
            stats1.errors++;
    end
    endtask

    // Test runner
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        enable = 1;

        stats1.errors = 0;
        stats1.clocks = 0;

        // Apply reset and start sequence
        #5 reset_n = 1;

        // Test case 1: FSM starts in RED
        check_output(0, 1, 0, 0);

        // Test case 2: Transition to GREEN after 32 cycles
        repeat (32) @(posedge clk);
        check_output(32, 0, 0, 1);

        // Test case 3: Transition to YELLOW after 20 cycles
        repeat (20) @(posedge clk);
        check_output(52, 0, 1, 0);

        // Test case 4: Transition back to RED after 7 cycles
        repeat (7) @(posedge clk);
        check_output(59, 1, 0, 0);

        // Final summary (AutoChip compatible)
        $display("Hint: Total mismatched samples is %0d out of %0d samples\n",
                 stats1.errors, stats1.clocks);
        $display("Mismatches: %0d in %0d samples",
                 stats1.errors, stats1.clocks);

        $finish;
    end

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("my_design.vcd");
        $dumpvars(0, tb_traffic_light_fsm);
    end

endmodule

