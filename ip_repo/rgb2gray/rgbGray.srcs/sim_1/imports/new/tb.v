`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 08:11:41 PM
// Design Name: 
// Module Name: tb
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

`define imageSize 512*512*3

module tb(

    );
    
 
 reg clk;
 reg reset;
 reg [23:0] imgData;
 integer file,file1,i;
 reg imgDataValid;
 integer sentSize;
 wire [7:0] rgbOutData;
 wire rgbOutDataValid;
 integer receivedData=0;
 initial
 begin
    clk = 1'b0;
    forever
    begin
        #5 clk = ~clk;
    end
 end
 
 initial
 begin
    reset = 0;
    sentSize = 0;
    imgDataValid = 0;
    #100;
    reset = 1;
    #100;
    file = $fopen("lena_color.bin","rb");
    file1 = $fopen("lenaGrey.bin","wb");
        
    for(i=0;i<512*512;i=i+1)
    begin
        @(posedge clk);
        $fscanf(file,"%c%c%c",imgData[7:0],imgData[15:8],imgData[23:16]);
        imgDataValid <= 1'b1;
    end
    @(posedge clk);
    imgDataValid <= 1'b0;
    $fclose(file);
 end
 
 always @(posedge clk)
 begin
     if(rgbOutDataValid)
     begin
         $fwrite(file1,"%c",rgbOutData);
         receivedData = receivedData+1;
     end 
     if(receivedData == `imageSize/(3))
     begin
        $fclose(file1);
        $stop;
     end
 end
 
 rgb2grey dut(
    .axi_clk(clk),
    .axi_reset_n(reset),
    //slave interface
    .i_rgb_data_valid(imgDataValid),
    .i_rgb_data(imgData),
    .o_rgb_data_ready(),
    //master interface
    .o_greyScale_data_valid(rgbOutDataValid),
    .o_grey_data(rgbOutData),
    .i_grey_ready(1'b1)
);  
 
endmodule
