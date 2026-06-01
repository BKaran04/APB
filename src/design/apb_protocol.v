`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 07:47:26 PM
// Design Name: 
// Module Name: apb_protocol
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

module apb_protocol (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire        transfer,
    input  wire        READ_WRITE,

    input  wire [8:0]  apb_write_paddress,
    input  wire [7:0]  apb_write_data,
    input  wire [8:0]  apb_read_paddress,
    output wire [7:0]  apb_read_data_out
);

wire [7:0] PADDR;
wire        PSEL1_M, PSEL2_M;   
wire        PENABLE;
wire        PWRITE;
wire [7:0]  PWDATA;
wire        PREADY;
wire [7:0]  PRDATA;
wire        PSEL1_S, PSEL2_S;
wire        PREADY1;
wire [7:0]  PRDATA1;
wire        PREADY2;
wire [7:0]  PRDATA2;

apb_master u_master (
    .PCLK                (PCLK),
    .PRESETn             (PRESETn),
    .transfer            (transfer),
    .READ_WRITE          (READ_WRITE),
    .apb_write_paddress  (apb_write_paddress),
    .apb_write_data      (apb_write_data),
    .apb_read_paddress   (apb_read_paddress),
    .apb_read_data_out   (apb_read_data_out),
    .PADDR               (PADDR),
    .PSEL1               (PSEL1_M),
    .PSEL2               (PSEL2_M),
    .PENABLE             (PENABLE),
    .PWRITE              (PWRITE),
    .PWDATA              (PWDATA),
    .PREADY              (PREADY),
    .PRDATA              (PRDATA)
);

apb4_mux u_mux (
    .MST_PSEL1      (PSEL1_M),
    .MST_PSEL2      (PSEL2_M),
    .SLV_PREADY1    (PREADY1),
    .SLV_PRDATA1    (PRDATA1),
    .SLV_PREADY2    (PREADY2),
    .SLV_PRDATA2    (PRDATA2),
    .SLV_PSEL_OUT1  (PSEL1_S),
    .SLV_PSEL_OUT2  (PSEL2_S),
    .MST_PREADY     (PREADY),
    .MST_PRDATA     (PRDATA)
);

apb_slave u_slave1 (
    .PCLK    (PCLK),
    .PRESETn (PRESETn),
    .PSEL    (PSEL1_S),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PADDR   (PADDR),
    .PWDATA  (PWDATA),
    .PRDATA  (PRDATA1),
    .PREADY  (PREADY1),
    .PSLVERR ()
);

apb_slave u_slave2 (
    .PCLK    (PCLK),
    .PRESETn (PRESETn),
    .PSEL    (PSEL2_S),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PADDR   (PADDR),
    .PWDATA  (PWDATA),
    .PRDATA  (PRDATA2),
    .PREADY  (PREADY2),
    .PSLVERR ()
);

endmodule


