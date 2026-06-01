`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 07:42:15 PM
// Design Name: 
// Module Name: apb_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module apb_slave (
    input  wire        PCLK,
    input  wire        PRESETn,

    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [7:0]  PADDR,
    input  wire [7:0]  PWDATA,

    output wire [7:0]  PRDATA,
    output wire        PREADY,
    output wire        PSLVERR
);

assign PREADY  = PSEL & PENABLE;
assign PSLVERR = 1'b0;

reg [7:0] mem [0:255];

integer i;

always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] <= 8'b0;
    end else begin
        if (PSEL && PENABLE && PWRITE)
            mem[PADDR] <= PWDATA;
    end
end

assign PRDATA = (PSEL && !PWRITE) ? mem[PADDR] : 8'b0;

endmodule


