`timescale 1ns/1ps

module i2c_master(
    input clk,
    input reset,
    input start,
    input [6:0] addr,
    output reg scl,
    inout sda,
    output reg done,
    output reg [7:0] data_out
);

reg [3:0] state;
reg [3:0] bit_cnt;
reg [7:0] shift_reg;
reg sda_out;
reg sda_en;

assign sda = (sda_en) ? sda_out : 1'bz;

parameter IDLE  = 0,
          START = 1,
          ADDR  = 2,
          ACK1  = 3,
          READ  = 4,
          ACK2  = 5,
          STOP  = 6;

always @(posedge clk or posedge reset) begin

    if (reset) begin
        state    <= IDLE;
        scl      <= 1;
        sda_out  <= 1;
        sda_en   <= 1;
        done     <= 0;
    end

    else begin

        case(state)

            IDLE: begin
                done <= 0;

                if(start)
                    state <= START;
            end

            START: begin
                sda_out  <= 0;
                scl      <= 1;
                shift_reg <= {addr,1'b1};
                bit_cnt  <= 7;
                state    <= ADDR;
            end

            ADDR: begin
                scl      <= 0;
                sda_out  <= shift_reg[bit_cnt];
                scl      <= 1;

                if(bit_cnt == 0)
                    state <= ACK1;
                else
                    bit_cnt <= bit_cnt - 1;
            end

            ACK1: begin
                scl    <= 0;
                sda_en <= 0;
                scl    <= 1;
                state  <= READ;
                bit_cnt <= 7;
            end

            READ: begin
                scl    <= 0;
                sda_en <= 0;
                scl    <= 1;

                data_out[bit_cnt] <= sda;

                if(bit_cnt == 0)
                    state <= ACK2;
                else
                    bit_cnt <= bit_cnt - 1;
            end

            ACK2: begin
                scl     <= 0;
                sda_en  <= 1;
                sda_out <= 1;
                scl     <= 1;
                state   <= STOP;
            end

            STOP: begin
                scl     <= 1;
                sda_out <= 1;
                done    <= 1;
                state   <= IDLE;
            end

        endcase
    end
end

endmodule
