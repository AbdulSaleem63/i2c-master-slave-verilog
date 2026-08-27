module tb_i2c;

reg clk = 0;
reg reset = 0;
reg start = 0;
reg [6:0] addr = 7'b1010101;

wire scl;
wire sda;
wire done;
wire [7:0] data_out;

i2c_master uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .addr(addr),
    .scl(scl),
    .sda(sda),
    .done(done),
    .data_out(data_out)
);

i2c_slave slave (
    .scl(scl),
    .sda(sda)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("i2c.vcd");
    $dumpvars(0,tb_i2c);

    reset = 1;
    #10;

    reset = 0;

    start = 1;
    #10;

    start = 0;

    #500 $stop;

end

endmodule
