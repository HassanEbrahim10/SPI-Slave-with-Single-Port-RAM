module Wrapper (MOSI , MISO , clk , rst_n , SS_n);


input MOSI ,  clk , rst_n , SS_n;
output  MISO ;

wire tx_valid  ;
wire [7:0] tx_data ;

wire rx_valid ;
wire [9:0] rx_data ;

wire [9 : 0] din ;

wire [7:0] dout ;


assign din = rx_data;
assign tx_data = dout ;

RAM RAM_inst (din , rx_valid , clk , rst_n , dout , tx_valid);
SPI_Slave SPI_Slave_inst (MOSI , tx_valid , clk , rst_n,SS_n,tx_data,rx_valid,rx_data , MISO);

endmodule

