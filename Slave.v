module SPI_Slave (MOSI , tx_valid , clk , rst_n,SS_n,tx_data,rx_valid,rx_data , MISO);
parameter IDLE = 3'b000 ;
parameter CHK_CMD = 3'b001 ;
parameter WRITE = 3'b010 ;
parameter READ_DATA = 3'b011;
parameter READ_ADD = 3'b100 ;
input MOSI , tx_valid , clk , rst_n ;
input SS_n ;
input [7:0] tx_data ;
output reg MISO , rx_valid ;
output reg [9:0] rx_data ;

reg [9:0] data_out ; // from slave to RAM
reg [7:0] data_in ; // from RAM to slave
reg [4:0] counter ;
reg Read_en ;

reg[2:0] cs , ns ;


// State Memory 

always @(posedge clk) begin
	if (!rst_n) begin
		cs <= IDLE ;
	end
	else begin
		cs <= ns ;
	end
end

// Next State Logic

always @(*) begin
	case (cs)
		IDLE : 
			if (!SS_n) 
				ns = CHK_CMD ;
			else 
				ns = IDLE ;

		CHK_CMD :
			if (SS_n == 0 && MOSI == 0)
				ns = WRITE ;
			else if (SS_n == 0 && MOSI == 1)begin
				if (!Read_en)
					ns = READ_ADD;
				else 
					ns = READ_DATA;
				// Read_en = 1 ;
			end else
				ns = IDLE ;

		WRITE : 
			if (SS_n) 
				ns = IDLE ;
			else 
				ns = WRITE ;

		READ_ADD : 
			if (SS_n) 
				ns = IDLE ;
			else 
				ns = READ_ADD ;

		READ_DATA :
			if (SS_n) 
				ns = IDLE ;
			else 
				ns = READ_DATA ;
		
		default : ns = IDLE ; 		
		
	endcase // cs
end



// Output Logic
always @(posedge clk ) begin
	if (!rst_n) begin
		MISO 		<= 0 ;
		data_out 	<= 0 ;
		data_in 	<= 0 ;
		rx_valid 	<= 0 ;
		rx_data 	<= 0 ;
		counter		<= 0 ;
		Read_en		<= 0 ;
	end
	else begin
		case (cs)
			WRITE :
					begin
					 	if (counter < 10)begin
					 		data_out <= {data_out , MOSI};
					 	end else begin
					 		rx_data <= data_out ;
					 		if(!data_out[9])begin
					 			rx_valid 	<= 1 ;
					 		end else begin
					 			rx_valid 	<= 0 ;
					 		end
					 	end
					 	counter <= counter + 1 ;
					 end 
			READ_ADD : 
					begin
					 	if (counter < 10)begin
					 		data_out <= {data_out , MOSI};
					 	end else begin
					 		rx_data <= data_out ;
					 		if(data_out[9:8]==2'b10)begin
					 			rx_valid 	<= 1 ;
					 			Read_en		<= 1 ;
					 		end else begin
					 			rx_valid 	<= 0 ;
					 		end
					 	end
					 	counter <= counter + 1 ;
					 end 
			READ_DATA : /* SPI call RAM --- SPI and RAM are Active --- SPI receive Data and serialized it */
					begin
					 	if (counter < 10)begin
					 		data_out <= {data_out , MOSI};
					 	end else if (counter == 10) begin
					 		rx_data <= data_out ;
					 		if(data_out[9:8]==2'b11)begin
					 			rx_valid 	<= 1 ;
					 			Read_en		<= 0 ;
					 		end else begin
					 			rx_valid 	<= 0 ;
					 		end
					 	end else if (counter == 11 && !tx_valid)begin
					 		rx_valid 	<= 0 ;
					 	end else if (counter == 12 && tx_valid)begin
					 		data_in 	<= tx_data  ;
					 	end else if (counter <= 20 && counter > 12 && !tx_valid)begin
					 		MISO 	<= data_in[7];
					 		data_in <= {data_in , 1'b0};
					 	end else begin
					 		MISO <= 0 ;
					 	end
					 	counter <= counter + 1 ;
					 end 
			default : 
					begin
						MISO 		<= 0 ;
						data_out 	<= 0 ;
						data_in 	<= 0 ;
						rx_valid 	<= 0 ;
						counter		<= 0 ;
					end
		endcase
	end
end


endmodule