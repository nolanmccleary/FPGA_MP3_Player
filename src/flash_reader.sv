module flash_reader
    (
        input logic reader_clk,
        input logic flash_mem_waitrequest,
        input logic flash_mem_readdatavalid,
        input logic [31:0] flash_mem_readdata, 

        output logic [31:0] flash_data
    );

    always_ff @(posedge reader_clk) begin
        flash_data <= (~flash_mem_waitrequest & flash_mem_readdatavalid)? flash_mem_readdata : 32'b0;
    end

endmodule