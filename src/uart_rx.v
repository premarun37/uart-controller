module uart_rx #(
	parameter clk_per_bit = 868
	)(
	input clk, rst,
	input rx,
	
	output reg [7:0] rx_data,
	output reg rx_done
	);
	
	localparam IDLE = 2'b00;
	localparam START = 2'b01;
	localparam DATA = 2'b10;
	localparam STOP = 2'b11;
	
	reg [7:0] shift_reg;
	reg [2:0] bit_count;
	reg [15:0] baud_count;
	
	reg rx_sync1, rx_sync2;
	
	reg [1:0] state;
	
	always @(posedge clk) begin
		rx_sync1 <= rx;
		rx_sync2 <= rx_sync1;
    	end
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			state <= IDLE;
			rx_data <= 8'b0;
			rx_done <= 1'b0;
			shift_reg <= 8'b0;
			bit_count <= 3'b0;
			baud_count <= 16'b0;
		end
		else begin
			rx_done <= 1'b0;
			
			case (state)
				IDLE :
				begin
					bit_count <= 3'b0;
					baud_count <= 16'b0;
					
					if (rx_sync2 == 1'b0) begin
						state <= START;
					end
				end
				
				START :
				begin
					if (baud_count == (clk_per_bit / 2) - 1) begin
					
						baud_count <= 16'b0;
						
						if (rx_sync2 == 1'b0) begin
							state <= DATA;
						end
						else begin
							state <= IDLE;
						end
					end
					else begin 
					
						baud_count <= baud_count + 1'b1;
					end
				end
				
				DATA : 
				begin
					if (baud_count == clk_per_bit -1) begin
					
						baud_count <= 16'b0;
						shift_reg[bit_count] <= rx_sync2;
						
						if (bit_count == 3'b111) begin
							state <= STOP;
							bit_count <= 3'b0;
						end
						else begin
							bit_count <= bit_count + 1'b1;
						end
					end
					else begin
						baud_count <= baud_count + 1'b1;
					end
				end
				
				STOP :
				begin
					if (baud_count == clk_per_bit - 1) begin
					
						baud_count <= 16'b0;
						state <= IDLE;
						
						if (rx_sync2 == 1'b1) begin
							rx_data <= shift_reg;
							rx_done <= 1'b1;
						end
					end
					else begin
						baud_count <= baud_count + 1'b1;
					end
				end
			endcase
		end
	end
	
endmodule
