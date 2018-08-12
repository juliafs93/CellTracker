%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A]=  Read5dFrames(Filename, Channels, Slices, Frames);
%Filename = [Path,File];
    info = imfinfo(Filename,'tif');
    %num_images = numel(info);   
    A = zeros(info(1).Height(1),info(1).Width,Channels,Slices,Frames);
    %TifLink = Tiff(Filename, 'r');
    %Tags = TifLink.getTagNames();
    for f = 1:Frames
        for z = 1:Slices
            for c = 1:Channels
                k = (f-1)*Channels*Slices + (z-1)*Channels + c;
                %k = (f-1)*num_images/Frames + (z-1)*num_images/(Frames*Slices) + c;
                A(:,:,c,z,f) = double(imread(Filename,'index',k,'Info',info));  
                %TifLink.setDirectory(k);
                %A(:,:,c,z,f)=TifLink.read();
                %Ti = Tiff(Ti,'w8');
                %A(:,:,c,z,f) = Ti

            end
        end
    end
    %TifLink.close();
end