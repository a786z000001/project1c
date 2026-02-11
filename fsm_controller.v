module fsm_controller (
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire done,
    input  wire error,
    output reg  busy,
    output reg  valid,
    output reg  fault
);

    reg [2:0] current_state, next_state;

    localparam IDLE  = 3'b000,
               INIT  = 3'b001,
               RUN   = 3'b010,
               DONE  = 3'b011,
               ERROR = 3'b100;

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:  if (start) next_state = INIT;
            INIT:  next_state = RUN;
            RUN:   if (error) next_state = ERROR;
                   else if (done) next_state = DONE;
            DONE:  next_state = DONE;
            ERROR: next_state = ERROR;
        endcase
    end

    // Output logic
    always @(*) begin
        busy  = 0;
        valid = 0;
        fault = 0;

        case (current_state)
            INIT, RUN: busy = 1;
            DONE:     valid = 1;
            ERROR:    fault = 1;
        endcase
    end

endmodule
