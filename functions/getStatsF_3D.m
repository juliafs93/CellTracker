function [Stats_GFP maxF minF] = getStatsF_3D(varargin)
    RFP_FTL_tracked = varargin{1};
    F_max = varargin{2};
    
    Stats_GFP = cell(size(RFP_FTL_tracked,4),1);
    maxF=0;
    minF=255;

    for f = 1:size(RFP_FTL_tracked,4)
        Stats_GFP{f,1} = regionprops('table',RFP_FTL_tracked(:,:,:,f),F_max(:,:,:,f),'PixelIdxList','PixelList','Centroid','MaxIntensity','MeanIntensity','PixelValues','Area');
        maxF = max([maxF,Stats_GFP{f,1}.MeanIntensity']);
        minF = min([minF,Stats_GFP{f,1}.MeanIntensity']);
    end
end