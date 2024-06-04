module flashdriver
    #(
        parameter WIDTH = 16
    )
    (
        input logic address_clk,
        input logic sample_clk,
        input logic [31:0] address_clk_count,
        
        input logic reset, //resets read status and adress position
        input logic enable, //shuts off address driver clock
        input logic reverse,

        input logic flash_mem_readdatavalid,
        input logic flash_mem_waitrequest,
        input logic [31:0] flash_mem_readdata,

        output logic fetch_clock_tap,

        output logic flash_mem_read,
        output logic [22:0] flash_mem_address,
        output logic [7:0] audio_out,
        output logic valid_read_flag
    );
    
    logic fetch_clock;
    assign fetch_clock_tap = fetch_clock;

    logic [31:0] flash_data;

    clock_divider #(.WIDTH(WIDTH)) divider(
        .clk(address_clk), 
        .enable(enable), 
        .clk_count(address_count), 
        .clk_out(fetch_clock)
    );

    flash_reader reader(
        .reset(reset),
        .sample_clk(sample_clk),
        .address_clk(fetch_clock),
        .flash_mem_readdatavalid(flash_mem_readdatavalid),
        .flash_mem_readdata(flash_mem_readdata),
        .flash_mem_read(flash_mem_read),
        .flash_data(flash_data),
        .valid_read_flag(valid_read_flag)
    );

    assign audio_out = flash_data[31:25];
    assign flash_mem_address = 23'h7EFE;

    /*
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
    */

endmodule
