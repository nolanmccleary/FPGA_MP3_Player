module flash_fetcher //flash fetcher FSM
    (
        input logic reset,
        input logic fetchClk,
        input logic reverse,

        output logic [7:0] out
    )

    /*
    assign flash_mem_write = 1'b0; put in flash fsm
    assign flash_mem_writedata = 32'b0;
    assign flash_mem_burstcount = 6'b000001;
    */

    logic [31:0] curr_word;
    logic [31:0] next_word;

    logic [1:0] curr_byte;
    logic [1:0] next_byte;

    logic [7:0] flash_data;
    logic flashClk;
    assign flashClk = CLK_50M;

    address_select sel(.curr_word(curr_word), .curr_byte(curr_byte), .next_word(next_word), .next_byte(next_byte), .reset(reset), .reverse(reverse));
    flash_reader reader(.row(curr_word), .column(curr_byte), .out(flash_data), .clk(CLK_50M));

    always_ff @(posedge fetchClk) begin
        curr_word <= next_word;
        curr_byte <= next_byte;
        out <= flash_data; 
    end

endmodule