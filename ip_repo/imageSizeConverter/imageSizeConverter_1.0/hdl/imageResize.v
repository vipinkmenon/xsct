module imageResize(
input   axi_aclk,
input   axi_reset_n,
input   [31:0] i_image_width,
input   [31:0] i_image_depth,
input   [31:0] i_width_scale,
input   [31:0] i_depth_scale,
input   [7:0]  i_image_data,
input          i_image_data_valid,
output         o_image_data_ready,
output reg [7:0]  o_image_data,
output reg     o_image_data_valid,
input          i_image_data_ready
); 

integer columnCounter=0;
integer rowCounter=0;
integer pixelCounter=0;
integer sumData;

assign o_image_data_ready = i_image_data_ready;

always @(posedge axi_aclk)
begin
    if(i_image_data_valid & o_image_data_ready)
        if(pixelCounter == (i_image_width-1))
        begin
            pixelCounter <= 0;
            if(rowCounter == (i_depth_scale-1))
                rowCounter <= 0;
            else
                rowCounter <= rowCounter+1;
        end    
        else
            pixelCounter <= pixelCounter+1;
end


always @(posedge axi_aclk)
begin
    if(i_image_data_valid & o_image_data_ready)
        if(columnCounter == (i_width_scale-1))
            columnCounter <= 0;
        else
            columnCounter <= columnCounter+1;
end



always @(posedge axi_aclk)
begin
    if(i_image_data_valid & o_image_data_ready)
        o_image_data <= i_image_data;
end

always @(posedge axi_aclk)
begin
    if(i_image_data_valid & columnCounter==0 & rowCounter==0)
        o_image_data_valid <= 1'b1;
    else
        o_image_data_valid <= 1'b0;
end


endmodule