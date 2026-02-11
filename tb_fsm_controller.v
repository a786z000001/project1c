module tb_fsm_controller;

    reg clk, reset, start, done, error;
    wire busy, valid, fault;

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

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, tb_fsm_controller);

        clk = 0;
        reset = 1;
        start = 0;
        done = 0;
        error = 0;

        #20 reset = 0;
        #10 start = 1;
        #10 start = 0;

        #30 done = 1;
        #10 done = 0;

        #40 reset = 1;
        #10 reset = 0;

        #30 error = 1;
        #10 error = 0;

        #50 $finish;
    end

endmodule
