`timescale 1ns/1ps
module apb_slave (
    input  wire PCLK,
    input  wire PRESETn,
    input  wire PSEL,
    input  wire PENABLE,
    input  wire PWRITE,
    input  wire [7:0]PADDR,
    input  wire [7:0]PWDATA,
    output reg [7:0]PRDATA,
    output reg PREADY,
    output reg PSLVERR
);
reg [7:0]mem[0:127];
integer i;
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        for(i=0; i<128; i=i+1) begin
            mem[i] <= 8'h00; 
        end
        PRDATA <= 8'h00;
        PREADY <= 1'b0;
        PSLVERR <= 1'b0;
    end
    else begin
        PREADY <= 1'b0;
        PSLVERR <= 1'b0;
        if (PSEL && PENABLE) begin
            PREADY <= 1'b1;
            if (PADDR <= 8'h7F) begin
                if (PWRITE)
                    mem[PADDR] <= PWDATA;
                else
                    PRDATA <= mem[PADDR];
            end
            else begin
                PSLVERR <= 1'b1;
                PRDATA <= 8'h00;
            end
        end
    end
end
endmodule
