module flashdriver
    #(
        parameter WIDTH = 16
    )
    (
        /////////////////////////////////////////////////
        input logic flash_mem_waitrequest,
        input logic flash_mem_readdata, 
        input logic flash_mem_readdatavalid,
        ////////////////////////////////////////////////

        input logic reset,
        input logic address_clk,
        input logic reader_clk,
        input logic enable,
        input logic reverse,
        input logic [WIDTH-1:0] count,

        ///////////////////////////////////////////OUTPUTS FOR DEBUGGING
        output logic fetch_clock_tap,
        output logic [1:0] out_byte,

        output logic [22:0] flash_mem_address,
        output logic [7:0] audio_out
    );
    
    logic fetch_clock;
    assign fetch_clock_tap = fetch_clock; //fetch_clock_tap used here for debugger

    logic [1:0] curr_byte;
    assign out_byte = curr_byte; //out_byte used here for debugger

    logic [31:0] flash_data;
    logic [7:0] audio_data;

    clock_divider #(.WIDTH(WIDTH)) divider(
        .clk(address_clk), 
        .enable(enable), 
        .clk_count(count), 
        .clk_out(fetch_clock)
    );

    //FSM goes here;
    flash_fetcher fetcher(
        .reset(reset), 
        .fetch_clock(fetch_clock), 
        .reverse(reverse),  

        .flash_mem_waitrequest(flash_mem_waitrequest),
        .flash_mem_readdata(flash_mem_readdata),
        .flash_mem_readdatavalid(flash_mem_readdatavalid),
        
        .flash_mem_address(flash_mem_address),
        .out_byte(curr_byte)
    );

    flash_reader reader(
        .reader_clk(reader_clk),
        .flash_mem_waitrequest(flash_mem_waitrequest),
        .flash_mem_readdatavalid(flash_mem_readdatavalid),
        .flash_mem_readdata(flash_mem_readdata),

        .flash_data(flash_data)
    );

    always_comb begin
        case(curr_byte) 
            2'b00: audio_data = flash_data[7:0];
            2'b01: audio_data = flash_data[15:8];
            2'b10: audio_data = flash_data[23:16];
            2'b11: audio_data = flash_data[31:24];
            default: audio_data = 8'b0;
        endcase
    end

    always_ff @(posedge reader_clk) begin
        if(enable) audio_out <= audio_data;
        else audio_out <= 8'b0;
    end

endmodule