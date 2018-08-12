function [RFPtoThreshold] = Filter_3D(varargin)
    RFPtoThreshold = varargin{1};
    MedFilt = varargin{2};
    show = varargin{3};
    SigmaFilt = 0; try SigmaFilt = varargin{4}; end
    for f=1:size(RFPtoThreshold,4)
        disp(['filtering f',num2str(f),'...']);
        if MedFilt ~= 0;
            %GaussianFilt = imgaussfilt3(RFPtoThreshold(:,:,:,f),sigmaFilt);
            RFPtoThreshold(:,:,:,f) = medfilt3(RFPtoThreshold(:,:,:,f),[MedFilt MedFilt MedFilt]);
        end
        if SigmaFilt ~= 0;
            GaussianFilt = imgaussfilt3(RFPtoThreshold(:,:,:,f),SigmaFilt);
        end
    end

    if strcmp(show,'on')==1;
        D=zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),1,size(RFPtoThreshold,4));
        D(:,:,1,:)=RFPtoThreshold(:,:,1,:);
        montage(D, [0 1]);
        D(:,:,1,:)=RFPtoThreshold(:,:,floor(size(RFPtoThreshold,3)/2),:);
        montage(D, [0 1]);
        D(:,:,1,:)=RFPtoThreshold(:,:,size(RFPtoThreshold,3),:);
        montage(D, [0 1]);
    end
end