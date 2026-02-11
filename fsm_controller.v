//====================================================
// FSM-based RTL Control Unit
// Author: Suchet
// Description:
//   Synchronous FSM modeling control logic commonly
//   used in SoC / ASIC subsystems.
//====================================================

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

    // State encoding
    localparam IDLE  = 3'b000,
               INIT  = 3'b001,
               RUN   = 3'b010,
               DONE  = 3'b011,
               ERROR = 3'b100;

    reg [2:0] current_state, next_state;

    //========================================
    // State Register (Synchronous Reset)
    //========================================
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    //========================================
    // Next-State Logic
    //========================================
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:  if (start) next_state = INIT;
            INIT:  next_state = RUN;
            RUN:   if (error) next_state = ERROR;
                   else if (done) next_state = DONE;
            DONE:  next_state = DONE;
            ERROR: next_state = ERROR;
            default: next_state = IDLE;
        endcase
    end

    //========================================
    // Output Logic (Moore-style)
    //========================================
    always @(*) begin
        busy  = 1'b0;
        valid = 1'b0;
        fault = 1'b0;

        case (current_state)
            INIT,
            RUN:   busy  = 1'b1;
            DONE:  valid = 1'b1;
            ERROR: fault = 1'b1;
        endcase
    end

endmodule
