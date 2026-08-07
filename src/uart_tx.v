module uart_tx(
	input clk, rst,
	input tx_start,
	input baud_tick,
	input [7:0] tx_data,
	output reg tx_done, tx
	);
	
	localparam IDLE = 2'b00;
	localparam START = 2'b01;
	localparam DATA = 2'b10;
	localparam STOP = 2'b11;
	
	reg [1:0] state;
	
	reg [7:0] shift_reg;
    	reg [2:0] bit_count;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state <= IDLE;
			tx <= 1'b1; // UART --> IDLE 
			tx_done   <= 1'b0;
            		shift_reg <= 8'd0;
            		bit_count <= 3'd0;
		end
		else begin
			tx_done <= 1'b0;
			
			case(state)
				IDLE :
				begin
					tx <= 1'b1;
					
					if(tx_start) begin
						shift_reg <= tx_data;
						bit_count <= 3'd0;
						state <= START;
						
					end
				end
				
				START :
				begin
					tx <= 1'b0;
					
					if (baud_tick) begin
						state <= DATA;
					end
				end
				
				DATA :
				begin
					tx <= shift_reg[0];
					
					if (baud_tick) begin
						shift_reg <= shift_reg >> 1;
						if (bit_count == 3'b111) begin
							state <= STOP;
						end
						else begin
							bit_count <= bit_count + 1'b1;
						end
					end
				end
				
				STOP :
				begin
					tx <= 1'b1;
					
					if (baud_tick) begin
						tx_done <= 1'b1;
						state <= IDLE;
					end
				end
				
				default : state <= IDLE;
			endcase
		end		
	end
		
endmodule
