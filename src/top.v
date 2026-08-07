module top (
	input  wire clk,
	input  wire rst,
	input  wire rx,
	output wire tx
);

	reg baud_tick;
	reg [15:0] baud_count;

	wire [7:0] rx_data;
	wire rx_done;
	
	reg [7:0] tx_data;
	reg tx_start;
	wire tx_done;
	
	localparam CLK_PER_BIT = 868;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			baud_count <= 0;
			baud_tick <= 0;
		end
		else begin
			if (baud_count == CLK_PER_BIT - 1) begin
				baud_count <= 0;
				baud_tick <= 1;
			end	
			else begin
				baud_count <= baud_count + 1;
				baud_tick <= 0;
			end
		end
	end
	
	uart_tx uart_tx0(
		.clk(clk),
		.rst(rst),
		
		.baud_tick(baud_tick),
				
		.tx_start(tx_start),
		.tx_data(tx_data),
		
		.tx_done(tx_done),
		.tx(tx)
		);
		
	uart_rx uart_rx0(
		.clk(clk),
		.rst(rst),
		
		.rx(rx),
		
		.rx_data(rx_data),
		.rx_done(rx_done)
		);	
		
	//looplock controller
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			tx_start <= 0;
			tx_data <= 0;
		end
		else begin
			tx_start <= 0;
			if (rx_done) begin
				tx_data <= rx_data;
				tx_start <= 1;
			end
		end
	end
	
endmodule
