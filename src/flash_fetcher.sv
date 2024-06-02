module flash_fetcher 
    #(
        parameter BASE = 0,
        parameter MAX_OFFSET = 16'h7FFF
    )
    (
        //////////////////////////////////////////////
        input logic flash_mem_waitrequest,
        input logic flash_mem_readdata, 
        input logic flash_mem_readdatavalid,

        output logic [22:0] flash_mem_address,
        /////////////////////////////////////////////

        input logic reset,
        input logic fetch_clock,
        input logic reverse,

        output logic [7:0] audio_out
    );


    logic [22:0] curr_word;
    logic [22:0] next_word;

    logic [1:0] curr_byte;
    logic [1:0] next_byte;

    logic [31:0] flash_data;
    logic [7:0] audio_slice;

    address_select sel(.curr_word(curr_word), .curr_byte(curr_byte), .next_word(next_word), .next_byte(next_byte), .reverse(reverse)); //update address
    
    always_comb begin
        flash_data = flash_mem_readdatavalid? flash_mem_readdata : 32'b0;
        case(curr_byte) 
            2'b00: audio_slice = flash_data[7:0];
            2'b01: audio_slice = flash_data[15:8];
            2'b10: audio_slice = flash_data[23:16];
            2'b11: audio_slice = flash_data[31:24];
            default: audio_slice = 8'b0;
        endcase
    end

    always_ff @(posedge fetch_clock) begin
        if(reset || (next_word > BASE + MAX_OFFSET)) begin //reset/out of bounds check
            curr_word <= BASE;
            curr_byte <= 2'b00;
            flash_mem_address <= BASE; // Initialize flash_mem_address during reset
            audio_out <= 8'b0; // Initialize audio_out during reset
        end 
        
        else begin
            curr_word <= next_word;
            curr_byte <= next_byte;
            flash_mem_address <= curr_word;
            audio_out <= audio_slice;
        end
    end
endmodule

