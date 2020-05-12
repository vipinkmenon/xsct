imageWidth = 512;
imageHeight = 512;
numColor = 3;

i=imread('lena_color.tiff');
fileID = fopen('lena_color.bin','w');
for r = 1:imageHeight
    for c = 1:imageWidth
        for m = 1:numColor
            fwrite(fileID,i(r,c,m));
        end
    end
end
fclose(fileID);