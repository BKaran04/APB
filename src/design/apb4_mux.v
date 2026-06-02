`timescale 1ns/1ps
module apb4_mux (
    input  wire        MST_PSEL,
    input  wire [8:0]  PADDR,      

    input  wire        SLV_PREADY1,
    input  wire [7:0]  SLV_PRDATA1,

    input  wire        SLV_PREADY2,
    input  wire [7:0]  SLV_PRDATA2,

    output wire        SLV_PSEL1,   
    output wire        SLV_PSEL2,   

    output wire        MST_PREADY,
    output wire [7:0]  MST_PRDATA
);

assign SLV_PSEL1 = MST_PSEL & ~PADDR[8];
assign SLV_PSEL2 = MST_PSEL &  PADDR[8];

assign MST_PREADY = PADDR[8] ? SLV_PREADY2 : SLV_PREADY1;
assign MST_PRDATA = PADDR[8] ? SLV_PRDATA2 : SLV_PRDATA1;

endmodule
