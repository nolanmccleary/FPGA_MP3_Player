module address_select
    #(
        parameter BASE = 69,
        parameter MAX_OFFSET = 420
        parameter WORD_DELTA = 1
    )
    (
        input logic reset,
        input logic reverse,
        input logic [31:0] curr_word,
        input logic [1:0] curr_byte,
        output logic [31:0] next_word,
        output logic [1:0] next_byte
    );


    localparam FIRST = 2'd0;
    localparam SECOND = 2'd1;
    localparam THIRD = 2'd2;
    localparam FOURTH = 2'd3;


    always_comb begin
        if((curr_word >= BASE + MAX_OFFSET) || (curr_word < BASE) || rst)begin   //TODO: implement circular looping if required
            next_word = BASE;
            next_byte = FIRST;
        end 

        else begin
            case(curr_byte)
                FIRST: begin
                    if(rev) begin
                        next_word = curr_word - WORD_DELTA;
                        next_byte = FOURTH;
                    end else begin
                        next_word = curr_word;
                        next_byte = SECOND;
                    end
                end

                SECOND: begin
                    next_word = curr_word;
                    if(rev) begin
                        next_byte = FIRST;
                    end else begin
                        next_byte = THIRD;
                    end
                end

                THIRD: begin
                    next_word = curr_word;
                    if(rev) begin
                        next_byte = SECOND;
                    end else begin
                        next_byte = FOURTH;
                    end
                end

                FOURTH: begin
                    if(rev) begin
                        next_word = curr_word;
                        next_byte = THIRD;
                    end else begin
                        next_word = curr_word + WORD_DELTA;
                        next_byte = FIRST;
                    end
                end
            endcase
        end
    end
endmodule