`timescale 1ns/1ps
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

wire [8:0]  PADDR;
wire        MST_PSEL;
wire        PENABLE;
wire        PWRITE;
wire [7:0]  PWDATA;

wire        MST_PREADY;
wire [7:0]  MST_PRDATA;

wire        SLV_PSEL1, SLV_PSEL2;
wire        SLV_PREADY1, SLV_PREADY2;
wire [7:0]  SLV_PRDATA1, SLV_PRDATA2;

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
    .MST_PSEL            (MST_PSEL),
    .PENABLE             (PENABLE),
    .PWRITE              (PWRITE),
    .PWDATA              (PWDATA),
    .PREADY              (MST_PREADY),
    .PRDATA              (MST_PRDATA)
);

apb4_mux u_mux (
    .MST_PSEL     (MST_PSEL),
    .PADDR        (PADDR),
    .SLV_PREADY1  (SLV_PREADY1),
    .SLV_PRDATA1  (SLV_PRDATA1),
    .SLV_PREADY2  (SLV_PREADY2),
    .SLV_PRDATA2  (SLV_PRDATA2),
    .SLV_PSEL1    (SLV_PSEL1),
    .SLV_PSEL2    (SLV_PSEL2),
    .MST_PREADY   (MST_PREADY),
    .MST_PRDATA   (MST_PRDATA)
);

apb_slave u_slave1 (
    .PCLK    (PCLK),
    .PRESETn (PRESETn),
    .PSEL    (SLV_PSEL1),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PADDR   (PADDR[7:0]),
    .PWDATA  (PWDATA),
    .PRDATA  (SLV_PRDATA1),
    .PREADY  (SLV_PREADY1),
    .PSLVERR ()
);

apb_slave u_slave2 (
    .PCLK    (PCLK),
    .PRESETn (PRESETn),
    .PSEL    (SLV_PSEL2),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PADDR   (PADDR[7:0]),
    .PWDATA  (PWDATA),
    .PRDATA  (SLV_PRDATA2),
    .PREADY  (SLV_PREADY2),
    .PSLVERR ()
);

endmodule
