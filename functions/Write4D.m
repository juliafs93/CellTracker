function[] = Write4D(toWrite, PathToSave, Suffix, Description)

for f = 1:size(toWrite,4)
    for z = 1:size(toWrite,3)
        if f==1&z==1
            imwrite(uint8(toWrite(:,:,1)), [PathToSave, Suffix],'Compression','none', 'Description',Description)
        else
            imwrite(uint8(toWrite(:,:,z,f)), [PathToSave, Suffix],'WriteMode','append','Compression','none','Description',Description)
        end
    end
end
end