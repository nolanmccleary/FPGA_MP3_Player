module flash_fsm
    #(
        parameter BASE = 0,
        parameter MAX_OFFSET = 22'h7FFFF)
    (
        input logic clk,
        input logic reset,
        input logic enable,
        input logic reverse,
        input logic flash_mem_waitrequest,

        output logic [1:0] out_byte,
        output logic [22:0] flash_mem_address
    );

    logic [22:0] curr_word;
    logic [22:0] next_word;
    logic [1:0] curr_byte;
    logic [1:0] next_byte;

    address_select sel(.curr_word(curr_word), .curr_byte(curr_byte), .next_word(next_word), .next_byte(next_byte), .reverse(reverse), .enable(enable), .flash_mem_waitrequest(flash_mem_waitrequest));

    always_ff @(posedge clk) begin
        if(reset || next_word > BASE + MAX_OFFSET) begin
            curr_word <= BASE;
            curr_byte <= 2'b0;
        end
        
        else begin
            curr_word <= next_word;
            curr_byte <= next_byte;
        end
    end

    assign out_byte = curr_byte;
    assign flash_mem_address = curr_word;

endmodule