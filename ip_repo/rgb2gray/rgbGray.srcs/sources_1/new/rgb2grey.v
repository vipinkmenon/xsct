`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2020 10:32:58 PM
// Design Name: 
// Module Name: rgb2grey
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb2grey(
input    axi_clk,
input    axi_reset_n,
input    i_rgb_data_valid,
input [23:0] i_rgb_data,
output   o_rgb_data_ready,
output reg  o_greyScale_data_valid,
output reg [7:0] o_grey_data,
input    i_grey_ready
);

wire [7:0] w_red;
wire [7:0] w_green;
wire [7:0] w_blue;
wire [31:0] filteredData;

assign o_rgb_data_ready = i_grey_ready;
assign w_red = i_rgb_data[7:0];
assign w_green = i_rgb_data[15:8];
assign w_blue = i_rgb_data[23:16];

always @(posedge axi_clk)
begin
    if(i_rgb_data_valid & o_rgb_data_ready)
        o_grey_data <= (w_red>>2)+(w_red>>5)+(w_green>>1)+(w_green>>4)+(w_blue>>4)+(w_blue>>5);
end

always @(posedge axi_clk)
begin
    o_greyScale_data_valid <= i_rgb_data_valid;
end

endmodule
