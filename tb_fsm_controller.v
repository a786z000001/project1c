//====================================================
// Testbench for FSM-based Control Unit
//====================================================

module tb_fsm_controller;

    reg clk;
    reg reset;
    reg start;
    reg done;
    reg error;

    wire busy;
    wire valid;
    wire fault;

    // DUT instantiation
    fsm_controller dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .error(error),
        .busy(busy),
        .valid(valid),
        .fault(fault)
    );

    // Clock generation (100 MHz equivalent)
    always #5 clk = ~clk;

    initial begin
        // Dump waveform
        $dumpfile("fsm.vcd");
        $dumpvars(0, tb_fsm_controller);

        // Initialize signals
        clk   = 0;
        reset = 1;
        start = 0;
        done  = 0;
        error = 0;

        $display("Time %0t : Reset asserted", $time);

        // Release reset
        #20 reset = 0;
        $display("Time %0t : Reset deasserted", $time);

        // Start operation
        #10 start = 1;
        $display("Time %0t : START asserted", $time);
        #10 start = 0;

        // Normal completion
        #30 done = 1;
        $display("Time %0t : DONE asserted", $time);
        #10 done = 0;

        // Reset again
        #40 reset = 1;
        $display("Time %0t : RESET asserted again", $time);
        #10 reset = 0;

        // Error scenario
        #30 error = 1;
        $display("Time %0t : ERROR asserted", $time);
        #10 error = 0;

        // End simulation
        #50;
        $display("Simulation finished");
        $finish;
    end

endmodule
