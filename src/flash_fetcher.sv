module flash_fetcher
    (
        input logic rst,
        input logic fetch_sig,
        input logic reverse,

        output logic [7:0] flash_data
    )


    logic [31:0] curr_word;
    logic [31:0] next_word;

    logic [1:0] curr_byte;
    logic [1:0] next_byte;


    initial begin
        curr_addr = BASE;
        next_addr = BASE;
    end

    address_select sel(.curr_word(curr_word), .curr_byte(curr_byte), .next_word(next_word), .next_byte(next_byte), .rst(rst));

    always_ff @(posedge fetch_sig) begin
        curr_word <= next_word;
        curr_byte <= next_byte;
        flahs_data <= READFLASHDATA;
    end



endmodule