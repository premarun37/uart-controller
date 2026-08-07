`timescale 1ns/1ps

module tb_top;

reg clk;
reg rst;
reg rx;
wire tx;

top uut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .tx(tx)
);

parameter BIT_PERIOD = 8680; // 115200 baud @100MHz

//----------------------------------------------------
// Clock Generation
//----------------------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz
end

//----------------------------------------------------
// Dump File
//----------------------------------------------------
initial begin
    $dumpfile("top_uart.vcd");
    $dumpvars(0, tb_top);
end

//----------------------------------------------------
// UART Transmit Task (drives RX input)
//----------------------------------------------------
task send_uart;
    input [7:0] data;
    integer i;
begin

    // Idle
    rx = 1'b1;
    #(BIT_PERIOD);

    // Start bit
    rx = 1'b0;
    #(BIT_PERIOD);

    // Data bits (LSB first)
    for(i = 0; i < 8; i = i + 1) begin
        rx = data[i];
        #(BIT_PERIOD);
    end

    // Stop bit
    rx = 1'b1;
    #(BIT_PERIOD);

end
endtask

//----------------------------------------------------
// Stimulus
//----------------------------------------------------
initial begin

    rst = 1;
    rx  = 1;

    #100;
    rst = 0;

    $display("\nSending A (0x41)");
    send_uart(8'h41);

    #100000;

    $display("\nSending B (0x42)");
    send_uart(8'h42);

    #100000;

    $display("\nSending C (0x43)");
    send_uart(8'h43);

    #100000;

    $finish;
end

/* always @(posedge clk) begin
    if (uut.rx_done) begin
        case(uut.rx_data)
            8'h41: $display("PASS: Received A");
            8'h42: $display("PASS: Received B");
            8'h43: $display("PASS: Received C");
            default: $display("FAIL: Unknown Data %h", uut.rx_data);
        endcase
    end
end */

reg [7:0] expected [0:2];
integer idx;

initial begin
    expected[0] = 8'h41;
    expected[1] = 8'h42;
    expected[2] = 8'h43;
    idx = 0;
end

always @(posedge clk) begin
    if (uut.rx_done) begin
        if (uut.rx_data == expected[idx])
            $display("PASS: Expected=%h Received=%h",
                     expected[idx], uut.rx_data);
        else
            $display("FAIL: Expected=%h Received=%h",
                     expected[idx], uut.rx_data);

        idx = idx + 1;
    end
end
endmodule
