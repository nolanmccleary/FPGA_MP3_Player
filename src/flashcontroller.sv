module flashcontroller
    #(
        parameter WIDTH = 16,
        parameter DRIVER_FREQ = 27_000
    )
    (
        input logic rst,
        input logic clk,
        input logic enable,
        input logic reverse,
        input logic [WIDTH-1:0] speed

        logic fetch_pulse;
    );


    clock_divider #(.WIDTH(WIDTH), .CLOCK_FREQ(DRIVER_FREQ)) divider(.clk(clk), .enable(enable), .freq_hertz(speed));




endmodule