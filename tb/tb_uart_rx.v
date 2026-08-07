module tb_uart_rx();
	reg clk, rst, rx;
	wire rx_done;
	wire [7:0] rx_data;
	
	uart_rx uut (
		.clk(clk),
		.rst(rst),
		.rx(rx),
		.rx_done(rx_done),
		.rx_data(rx_data)
		);
		
	initial begin
	    $dumpfile("uart_rx.vcd");
	    $dumpvars(0,tb_uart_rx);
	end
	
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	parameter CLK_FEQ = 100000000;
	parameter BAUD_RATE = 115200;
	localparam BIT_PERIOD = 8680;
	
	task send_uart_data;
		input [7:0] data;
		integer i;
		begin
			//IDLE 
			rx = 1'b1;
			#(BIT_PERIOD);
			
			//START
			rx = 1'b0;
			#(BIT_PERIOD);
			
			//DATA
			for (i = 0;i < 8;i = i + 1) begin
				rx = data[i];
				#(BIT_PERIOD);
			end
			
			//STOP
			rx = 1'b1;
			#(BIT_PERIOD);
			
		end
		
	endtask
	
	initial begin
		rst = 1'b1;
		rx = 1'b1;
		
		#100;
		rst = 1'b0;
		
		//Data = 'A' --> 01000001
		send_uart_data(8'h41);
		
		send_uart_data(8'h55); // 01010101
		send_uart_data(8'hAA); // 10101010
		send_uart_data(8'hFF);
		send_uart_data(8'h00);

		#100000;
		
		$finish;
	end
	
	initial begin
        	$monitor("Time=%0t rx=%b rx_data=%h rx_done=%b", $time, rx, rx_data, rx_done);
    	end
	
endmodule
