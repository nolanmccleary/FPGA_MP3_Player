//count-based clock divider

module clock_divider
    #(
        parameter WIDTH = 32
    )
    (
        input logic clk,
        input logic enable, 
        input logic [WIDTH-1:0] clk_count, 
        output logic clk_out
    );

    logic [31:0] pulseCount;
    logic [31:0] pulseLimit;

    always_ff @( posedge clk ) begin
        if(enable) begin
            pulseLimit <= clk_count;
        
            if (pulseCount >= pulseLimit) begin
                clk_out <= ~clk_out;
                pulseCount <= 0;    
            end
            
            else pulseCount <= pulseCount + 1;
        end
        
        else begin
            pulseCount <= 0;
            clk_out <= 0;
        end
    end
endmodule