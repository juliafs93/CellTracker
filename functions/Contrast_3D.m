function [RFPtoThreshold] = Contrast_3D(RFPtoThreshold, inputLow, inputHigh,show)
    for f=1:size(RFPtoThreshold,4)
        disp(['contrasting f',num2str(f),'...'])
        RFPtoThreshold(:,:,:,f) = RFPtoThreshold(:,:,:,f)./max(max(max(RFPtoThreshold(:,:,:,f))));
        for z=1:size(RFPtoThreshold,3)
            RFPtoThreshold(:,:,z,f) = imadjust(RFPtoThreshold(:,:,z,f),[inputLow; inputHigh],[0; 1]);
        end
    end

    if strcmp(show,'on')==1;
        D=zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),1,size(RFPtoThreshold,4));
        %D(:,:,1,:)=RFPtoThreshold(:,:,1,:);
        %montage(D, [0 1]);
        D(:,:,1,:)=RFPtoThreshold(:,:,floor(size(RFPtoThreshold,3)/2),:);
        montage(D, [0 1]);
        %D(:,:,1,:)=RFPtoThreshold(:,:,size(RFPtoThreshold,3),:);
        %montage(D, [0 1]);
    end
end