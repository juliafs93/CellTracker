function[] = WriteRGB(RGBtoWrite, PathToSave, Suffix,Compression)
imwrite(RGBtoWrite(:,:,:,1),jet, [PathToSave, Suffix],'Compression',Compression)
for f = 2:size(RGBtoWrite,4)
    imwrite(RGBtoWrite(:,:,:,f),jet, [PathToSave, Suffix],'WriteMode','append','Compression',Compression)
end
end