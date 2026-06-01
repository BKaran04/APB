`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 07:40:43 PM
// Design Name: 
// Module Name: apb_master
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

module apb_master (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire        transfer,
    input  wire        READ_WRITE,

    input  wire [8:0]  apb_write_paddress,
    input  wire [7:0]  apb_write_data,
    input  wire [8:0]  apb_read_paddress,
    output reg  [7:0]  apb_read_data_out,

    output reg  [7:0]  PADDR,
    output reg         PSEL1,
    output reg         PSEL2,
    output reg         PENABLE,
    output reg         PWRITE,
    output reg  [7:0]  PWDATA,

    input  wire        PREADY,
    input  wire [7:0]  PRDATA
);

localparam IDLE   = 2'b00;
localparam SETUP  = 2'b01;
localparam ACCESS = 2'b10;

reg [1:0] state;

always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        state             <= IDLE;
        PADDR             <= 8'b0;
        PSEL1             <= 1'b0;
        PSEL2             <= 1'b0;
        PENABLE           <= 1'b0;
        PWRITE            <= 1'b0;
        PWDATA            <= 8'b0;
        apb_read_data_out <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                PENABLE <= 1'b0;
                PSEL1   <= 1'b0;
                PSEL2   <= 1'b0;
                if (transfer)
                    state <= SETUP;
            end

            SETUP: begin
                PENABLE <= 1'b0;
                PWRITE  <= READ_WRITE;
                if (READ_WRITE) begin
                    PADDR  <= apb_write_paddress[7:0];
                    PWDATA <= apb_write_data;
                    PSEL1  <= ~apb_write_paddress[8];
                    PSEL2  <=  apb_write_paddress[8];
                end else begin
                    PADDR  <= apb_read_paddress[7:0];
                    PSEL1  <= ~apb_read_paddress[8];
                    PSEL2  <=  apb_read_paddress[8];
                end
                state <= ACCESS;
            end

            ACCESS: begin
                PENABLE <= 1'b1;
                if (PREADY) begin
                    PENABLE <= 1'b0;
                    if (!PWRITE)
                        apb_read_data_out <= PRDATA;

                    if (transfer) begin
                        state <= SETUP;   
                    end else begin
                        PSEL1 <= 1'b0;
                        PSEL2 <= 1'b0;
                        state <= IDLE;
                    end
                end
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule


