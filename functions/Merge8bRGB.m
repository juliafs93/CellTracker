function[Merged] = Merge8bRGB(EightBit, RGB,show)
Merged = RGB;
for f = 1:size(RGB,4)
%Merged(:,:,:,f) = imfuse(RFP_boundaries_RGB(:,:,:,f),RFP_FTL_tracked_meanF_noB(:,:,f), 'blend');
    Merged(:,:,1,f) = RGB(:,:,1,f)+EightBit(:,:,f);
    Merged(:,:,2,f) = RGB(:,:,2,f)+EightBit(:,:,f);
    Merged(:,:,3,f) = RGB(:,:,3,f)+EightBit(:,:,f);
%imshow(Merged);
end

        
if strcmp(show,'on')==1;
    mov = immovie(Merged);
    implay(mov)
end
end