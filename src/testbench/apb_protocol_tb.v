`timescale 1ns/1ps

module apb_protocol_tb;
reg PCLK = 0;
reg PRESETn = 0;
always #5 PCLK = ~PCLK;
reg transfer;
reg READ_WRITE;
reg  [8:0]apb_write_paddress;
reg  [7:0]apb_write_data;
reg  [8:0]apb_read_paddress;
wire [7:0]apb_read_data_out;

apb_protocol dut (.PCLK(PCLK),.PRESETn(PRESETn),.transfer(transfer),.READ_WRITE(READ_WRITE),.apb_write_paddress(apb_write_paddress),
.apb_write_data(apb_write_data),.apb_read_paddress(apb_read_paddress),.apb_read_data_out(apb_read_data_out));

wire [1:0]master_state = dut.u_master.state;
wire MST_PSEL = dut.MST_PSEL;
wire [8:0]PADDR = dut.PADDR;
wire PENABLE = dut.PENABLE;
wire PWRITE = dut.PWRITE;
wire [7:0]PWDATA = dut.PWDATA;
wire SLV_PSLVERR1 = dut.u_slave1.PSLVERR;
wire SLV_PSLVERR2 = dut.u_slave2.PSLVERR;
wire SLV_PSEL1 = dut.SLV_PSEL1;
wire SLV_PSEL2 = dut.SLV_PSEL2;
wire SLV_PREADY1 = dut.SLV_PREADY1;
wire SLV_PREADY2 = dut.SLV_PREADY2;
wire MST_PREADY = dut.MST_PREADY;
wire [7:0]MST_PRDATA = dut.MST_PRDATA;
wire [7:0]SLV_PRDATA1 = dut.SLV_PRDATA1;
wire [7:0]SLV_PRDATA2 = dut.SLV_PRDATA2;

task apply_reset;
    begin
        PRESETn  = 0;
        transfer = 0;
        READ_WRITE = 0;
        apb_write_paddress = 9'b0;
        apb_write_data = 8'b0;
        apb_read_paddress = 9'b0;
        repeat(4) @(posedge PCLK);
        PRESETn = 1;
        @(posedge PCLK);
    end
endtask

task apb_write (input [8:0] addr, input [7:0] data);
    begin
        @(posedge PCLK);
        apb_write_paddress = addr;
        apb_write_data = data;
        READ_WRITE = 1;
        transfer = 1;
        repeat(3) @(posedge PCLK);
        transfer = 0;
        READ_WRITE = 0;
        @(posedge PCLK);
        $display("[%0t] WRITE: addr=0x%03h  data=0x%02h", $time, addr, data);
    end
endtask

task apb_read (input [8:0] addr);
    begin
        @(posedge PCLK);
        apb_read_paddress = addr;
        READ_WRITE = 0;
        transfer = 1;
        repeat(3) @(posedge PCLK);
        transfer = 0;
        @(posedge PCLK);
        $display("[%0t] READ : addr=0x%03h  data=0x%02h", $time, addr, apb_read_data_out);
    end
endtask

initial begin
    $dumpfile("apb_protocol.vcd");
    $dumpvars(0, apb_protocol_tb);

    apply_reset;

    $display("---- Write to Slave1 (addr[8]=0) ----");
    apb_write(9'h010, 8'hAB);
    apb_write(9'h080, 8'hCD);

    $display("---- Read from Slave1 ----");
    apb_read(9'h010);
    apb_read(9'h080);

    $display("---- Write to Slave2 (addr[8]=1) ----");
    apb_write(9'h180, 8'h12);
    apb_write(9'h120, 8'h34);

    $display("---- Read from Slave2 ----");
    apb_read(9'h180);
    apb_read(9'h120);

    repeat(5) @(posedge PCLK);
    $display("Simulation complete.");
    $finish;
end

endmodule
