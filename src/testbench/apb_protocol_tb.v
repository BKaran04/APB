`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 07:50:47 PM
// Design Name: 
// Module Name: apb_protocol_tb
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

// =============================================================
// Testbench : apb_protocol_tb
// Tests:
//   1. Write to Slave1 (addr[8]=0)
//   2. Read  from Slave1
//   3. Write to Slave2 (addr[8]=1)
//   4. Read  from Slave2
// =============================================================

module apb_protocol_tb;

// -----------------------------------------------------------
// Clock & Reset
// -----------------------------------------------------------
reg  PCLK    = 0;
reg  PRESETn = 0;

always #5 PCLK = ~PCLK;   // 100 MHz

// -----------------------------------------------------------
// DUT ports
// -----------------------------------------------------------
reg        transfer;
reg        READ_WRITE;
reg  [8:0] apb_write_paddress;
reg  [7:0] apb_write_data;
reg  [8:0] apb_read_paddress;
wire [7:0] apb_read_data_out;

// -----------------------------------------------------------
// DUT instantiation
// -----------------------------------------------------------
apb_protocol dut (
    .PCLK                (PCLK),
    .PRESETn             (PRESETn),
    .transfer            (transfer),
    .READ_WRITE          (READ_WRITE),
    .apb_write_paddress  (apb_write_paddress),
    .apb_write_data      (apb_write_data),
    .apb_read_paddress   (apb_read_paddress),
    .apb_read_data_out   (apb_read_data_out)
);

// -----------------------------------------------------------
// Task : apply reset
// -----------------------------------------------------------
task apply_reset;
    begin
        PRESETn  = 0;
        transfer = 0;
        READ_WRITE = 0;
        apb_write_paddress = 9'b0;
        apb_write_data     = 8'b0;
        apb_read_paddress  = 9'b0;
        repeat(4) @(posedge PCLK);
        PRESETn = 1;
        @(posedge PCLK);
    end
endtask

// -----------------------------------------------------------
// Task : write cycle
// -----------------------------------------------------------
task apb_write (
    input [8:0] addr,
    input [7:0] data
);
    begin
        @(posedge PCLK);
        apb_write_paddress = addr;
        apb_write_data     = data;
        READ_WRITE         = 1;
        transfer           = 1;

        // SETUP -> ACCESS -> done (PREADY same cycle as ACCESS)
        repeat(3) @(posedge PCLK);

        transfer   = 0;
        READ_WRITE = 0;
        @(posedge PCLK);
        $display("[%0t] WRITE: addr=0x%03h  data=0x%02h", $time, addr, data);
    end
endtask

// -----------------------------------------------------------
// Task : read cycle
// -----------------------------------------------------------
task apb_read (
    input [8:0] addr
);
    begin
        @(posedge PCLK);
        apb_read_paddress = addr;
        READ_WRITE        = 0;
        transfer          = 1;

        repeat(3) @(posedge PCLK);

        transfer = 0;
        @(posedge PCLK);
        $display("[%0t] READ : addr=0x%03h  data=0x%02h", $time, addr, apb_read_data_out);
    end
endtask

// -----------------------------------------------------------
// Stimulus
// -----------------------------------------------------------
initial begin
    $dumpfile("apb_protocol.vcd");
    $dumpvars(0, apb_protocol_tb);

    apply_reset;

    $display("---- Write to Slave1 (addr[8]=0) ----");
    apb_write(9'h010, 8'hAB);
    apb_write(9'h020, 8'hCD);

    $display("---- Read from Slave1 ----");
    apb_read(9'h010);
    apb_read(9'h020);

    $display("---- Write to Slave2 (addr[8]=1) ----");
    apb_write(9'h110, 8'h12);
    apb_write(9'h120, 8'h34);

    $display("---- Read from Slave2 ----");
    apb_read(9'h110);
    apb_read(9'h120);

    repeat(5) @(posedge PCLK);
    $display("Simulation complete.");
    $finish;
end

endmodule


