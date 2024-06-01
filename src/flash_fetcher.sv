module flash_fetcher //TODO: Rework for BIG CHUNK
    #(
        parameter BASE = 0,
        parameter MAX_OFFSET = 16'h7FFF
    )
    (
        //////////////////////////////////////////////
        input logic flash_mem_waitrequest,
        input logic flash_mem_readdata, 
        input logic flash_mem_readdatavalid,

        output logic flash_mem_address;
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
        if(reset)begin //reset check
            curr_word = BASE;
            curr_byte = 2'b00;
        end 
        
        else if(curr_word > BASE + MAX_OFFSET) begin //out of bounds check
            curr_word = BASE;
            curr_byte = 2'b00;
        end 
        
        else begin    
            flash_data = flash_mem_readdatavalid? flash_mem_readdata : 32'b0;
            case(curr_byte)
                2'b00: audio_slice = flash_data[7:0];
                2'b01: audio_slice = flash_data[15:8];
                2'b10: audio_slice = flash_data[23:16];
                2'b11: audio_slice = flash_data[31:24];
            endcase
        end
    end


    always_ff @(posedge fetchClk) begin
        flash_mem_address <= curr_word;
        
        curr_word <= next_word;
        curr_byte <= next_byte;
        
        audio_out <= audio_slice;
    end

endmodule

