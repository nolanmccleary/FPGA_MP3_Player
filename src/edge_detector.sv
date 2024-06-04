module posedge_detector
    (
        input logic target,
        input logic clk,
        input logic rst,
        output logic out
    );

    logic curr;

    always_ff @(posedge clk) begin
        if (rst) begin
            out <= 0;
            curr <= 0;
        end
        else begin
            if(target & ~curr) out <= 1;
            else out <= 0;
            curr <= target;
        end
    end

endmodule