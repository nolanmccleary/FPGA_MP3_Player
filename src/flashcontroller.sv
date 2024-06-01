module flashcontroller
    #(
        parameter WIDTH = 16,
        parameter DRIVER_FREQ = 27_000
    )
    (
        input logic reset,
        input logic clk,
        input logic enable,
        input logic reverse,
        input logic [WIDTH-1:0] speed,

        output logic [7:0] audio_out
    );

    logic fetchClk;
    clock_divider #(.WIDTH(WIDTH), .CLOCK_FREQ(DRIVER_FREQ)) divider(.clk(clk), .enable(enable), .freq_hertz(speed), .out(fetchClk));

    //FSM goes here;
    flash_fetcher(.fetchClk(fetchClk), .reverse(reverse), .reset(reset), .out(audio_out));    


endmodule