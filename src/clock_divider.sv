module clock_divider
    #(
        parameter CLOCK_FREQ = 50_000_000,
        parameter WIDTH = 32
    )
    (
        input logic clk,
        input logic enable, 
        input logic [WIDTH-1:0] freq_hertz, 
        output logic clk_out
    );

    integer pulseCount;
    integer pulseLimit;
    
    initial begin
        pulseCount = 0;
        out = 0;
    end

    always_ff @( posedge clk ) begin
        if(enable) begin
            pulseLimit <= ((CLOCK_FREQ/freq_hertz)/2);
        
            if (pulseCount >= pulseLimit) begin
                out <= ~out;
                pulseCount <= 0;    
            end
            
            else pulseCount <= pulseCount + 1;
        end
        
        else out <= 0;
    end
endmodule