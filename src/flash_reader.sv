module flash_reader
    (
        input logic reset,
        
        input logic sample_clk,
        input logic address_clk,

        input logic flash_mem_readdatavalid,
        input logic [31:0] flash_mem_readdata, 

        output logic flash_mem_read,
        output logic valid_read_flag
    );

    //gets fresh read every adress clock pulse
    logic valid_read;
    logic address_switch;

    assign valid_read_flag = valid_read;

    posedge_detector detector(.rst(reset), .clk(sample_clk), .target(address_clk), .out(address_switch));


    always_ff @(posedge sample_clk) begin
        if(reset) begin
            valid_read <= 0;
            flash_mem_read <= 0;
        end

        else if(address_switch)begin
            valid_read <= 0;
            flash_mem_read <= 1;
        end

        else begin
            if(~valid_read)begin
                if(flash_mem_readdatavalid) begin
                    valid_read <= 1;
                    flash_mem_read <= 0;
                end
                else begin
                    valid_read <= 0;
                    flash_mem_read <= 1;
                end
            end
        end
    end


/*
always_ff @(posedge sample_clk) begin
    if(reset) begin
        flash_mem_read <= 0;
        valid_read <= 0;
        flash_data <= 32'b0;
    end
    else begin
        if (~valid_read_flag) begin
            flash_mem_read <= 1;
            valid_read <= 0;
        end
        if(flash_mem_readdatavalid) begin
            valid_read <= 1;
            flash_mem_read <= 0;
            flash_data <= flash_mem_readdata;
        end
    end
end
*/


endmodule