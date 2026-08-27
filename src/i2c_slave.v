module i2c_slave(
    input scl,
    inout sda
);

reg [7:0] data = 8'b10101010;
reg [3:0] bit_cnt = 7;
reg sda_out;
reg sda_en = 0;

assign sda = (sda_en) ? sda_out : 1'bz;

always @(negedge scl) begin

    sda_en  <= 1;
    sda_out <= data[bit_cnt];

    if(bit_cnt == 0)
        bit_cnt <= 7;
    else
        bit_cnt <= bit_cnt - 1;

end

endmodule
