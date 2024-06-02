module flashdriver
    #(
        parameter WIDTH = 16
    )
    (
        /////////////////////////////////////////////////
        input logic flash_mem_waitrequest,
        input logic flash_mem_readdata, 
        input logic flash_mem_readdatavalid,

        output logic [22:0] flash_mem_address,
        ////////////////////////////////////////////////

        input logic reset,
        input logic clk,
        input logic enable,
        input logic reverse,
        input logic [WIDTH-1:0] count,

        output logic [7:0] audio_out,

        ///////////////////////////////////////////OUTPUTS FOR DEBUGGING
        output logic fetch_clock_tap
    );
    
    logic fetch_clock;
    assign fetch_clock_tap = fetch_clock; 

    clock_divider #(.WIDTH(WIDTH)) divider(
        .clk(clk), 
        .enable(enable), 
        .clk_count(count), 
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