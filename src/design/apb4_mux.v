`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 07:44:37 PM
// Design Name: 
// Module Name: apb4_mux
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

module apb4_mux (
    input  wire        MST_PSEL1,
    input  wire        MST_PSEL2,
    input  wire        SLV_PREADY1,
    input  wire [7:0]  SLV_PRDATA1,
    input  wire        SLV_PREADY2,
    input  wire [7:0]  SLV_PRDATA2,
    output wire        SLV_PSEL_OUT1,
    output wire        SLV_PSEL_OUT2,
    output wire        MST_PREADY,
    output wire [7:0]  MST_PRDATA
);

assign SLV_PSEL_OUT1 = MST_PSEL1;
assign SLV_PSEL_OUT2 = MST_PSEL2;
assign MST_PREADY = MST_PSEL1 ? SLV_PREADY1 :
                    MST_PSEL2 ? SLV_PREADY2 : 1'b0;
assign MST_PRDATA = MST_PSEL1 ? SLV_PRDATA1 :
                    MST_PSEL2 ? SLV_PRDATA2 : 8'b0;
endmodule


