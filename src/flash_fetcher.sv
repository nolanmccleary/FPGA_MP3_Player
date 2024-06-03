module flash_fetcher 
    #(
        parameter BASE = 0,
        parameter MAX_OFFSET = 16'h7FFF
    )
    (
        input logic reset,
        input logic fetch_clock,
        input logic reverse,

        input logic flash_mem_waitrequest,
        input logic [31:0] flash_mem_readdata, 
        input logic flash_mem_readdatavalid,

        output logic [22:0] flash_mem_address,
        output logic [1:0] out_byte
    );

    logic [22:0] curr_word;
    logic [22:0] next_word;

    logic [1:0] curr_byte;
    logic [1:0] next_byte;

    
    address_select sel(.curr_word(curr_word), .curr_byte(curr_byte), .next_word(next_word), .next_byte(next_byte), .reverse(reverse), .flash_mem_waitrequest(flash_mem_waitrequest)); //update address

    always_ff @(posedge fetch_clock) begin
        if(reset || (next_word > BASE + MAX_OFFSET)) begin //reset/out of bounds check
            curr_word <= BASE;
            curr_byte <= 2'b00;
            flash_mem_address <= curr_word; 
        end else begin
            curr_word <= next_word;
            curr_byte <= next_byte;
            flash_mem_address <= curr_word;
        end
    end

    assign out_byte = curr_byte;

endmodule

