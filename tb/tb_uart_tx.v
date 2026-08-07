module tb_uart_tx();

	reg clk, rst, tx_start, baud_tick;
	reg [7:0] tx_data;
	wire tx_done, tx;
	
	uart_tx uut(
		.clk(clk),
		.rst(rst),
		.tx_start(tx_start),
		.baud_tick(baud_tick),
		.tx_data(tx_data),
		.tx_done(tx_done),
		.tx(tx)
		);
		
	initial begin
	    $dumpfile("uart_tx.vcd");
	    $dumpvars(0,tb_uart_tx);
	end
		
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		baud_tick = 0;
		forever begin
			#100;
			baud_tick = 1;
			#10;
			baud_tick = 0;
		end
	end
	
	initial begin
		rst = 1;
		tx_start = 0;
		tx_data = 8'b0;
		
		#50;
		rst = 0;
		
		#50;
		tx_data = 8'h41;
		tx_start = 1;
		
		#10;
		tx_start = 0;
		
		wait(tx_done);
		#200;

		tx_data = 8'h42;
		tx_start = 1;
		
		#10;
		tx_start = 0;
		
		wait(tx_done);
		#500;
		$finish;
		
	end
	
	initial begin
        	$monitor("TIME=%0t | TX=%b | TX_DONE=%b | STATE_DATA=%h", $time, tx, tx_done, tx_data);
    	end
endmodule
