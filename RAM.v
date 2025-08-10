module RAM (din , rx_valid , clk , rst_n , dout , tx_valid);
parameter MEM_DEPTH = 256 ;
parameter ADDR_SIZE = $clog2(MEM_DEPTH) ;	// log2(MEM_DEPTH)

input [9 : 0] din ;
input rx_valid , clk , rst_n ;
output reg [7:0] dout ;
output reg tx_valid ;

reg [9 : 0] mem [MEM_DEPTH - 1 :0];

wire [1:0] sel ;
reg [ADDR_SIZE - 1 : 0] addr_wr , addr_rd ;


assign sel = din [9 : 8] ;

always @(posedge clk) begin
	if (~rst_n) begin
		dout <= 0 ;
		tx_valid <= 0 ;
	end
	else begin
		if (rx_valid) begin
			if (sel  == 2'b00) begin
				addr_wr <= din[7 : 0];
				tx_valid <= 0 ;
			end
			else if (sel  == 2'b01)begin
					mem[addr_wr] <= din[7 : 0];
					tx_valid <= 0 ;
			end
			else if (sel  == 2'b10)begin
					addr_rd <= din[7 : 0];
					tx_valid <= 0 ;
			end
			else if (sel  == 2'b11)begin
					dout <= mem [addr_rd];
					tx_valid <= 1 ;
			end
		end else begin
			tx_valid <= 0 ;
		end

	end
end


endmodule 