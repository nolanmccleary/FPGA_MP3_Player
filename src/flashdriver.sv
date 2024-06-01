module flashdriver
    #(
        parameter WIDTH = 16,
        parameter DRIVER_FREQ = 27_000
    )
    (
        /////////////////////////////////////////////////
        input logic flash_mem_waitrequest,
        input logic flash_mem_readdata, 
        input logic flash_mem_readdatavalid,

        output logic flash_mem_address,
        ////////////////////////////////////////////////


        input logic reset,
        input logic clk,
        input logic enable,
        input logic reverse,
        input logic [WIDTH-1:0] speed,

        output logic [7:0] audio_out
    );
    
    logic fetch_clock;

    clock_divider #(.WIDTH(WIDTH), .CLOCK_FREQ(DRIVER_FREQ)) divider(
        .clk(clk), 
        .enable(enable), 
        .freq_hertz(speed), 
        .clk_out(fetch_clock)
    );

    //FSM goes here;
    flash_fetcher fetcher(
        .fetch_clock(fetch_clock), 
        .reverse(reverse), 
        .reset(reset), 
        .audio_out(audio_out),

        .flash_mem_waitrequest(flash_mem_waitrequest),
        .flash_mem_readdata(flash_mem_readdata),
        .flash_mem_readdatavalid(flash_mem_readdatavalid),
        .flash_mem_address(flash_mem_address)
    );    


endmodule