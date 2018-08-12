function [RFP_FTL RFP_FTL_RGB Stats_table] = SegmentNuc_3D(RFPtoThreshold, Function, parameters,show)
    RFP_FTL = zeros(size(RFPtoThreshold));
    RFP_FTL_RGB = zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),3,size(RFPtoThreshold,3));
    %Stats = cell(size(RFPtoThreshold,3),1);
    Stats_table = cell(size(RFPtoThreshold,4),1);
    for f=1:size(RFPtoThreshold,4)
        %[T_L T_L_RGB Stats] = FiltThresLab(img,LoGradius, level, areaopen)
        %[T_L T_L_RGB Stats] = ThresLabNBs(toThreshold,remove1, diskSize, WatershedParameter,remove2)
        [RFP_FTL(:,:,:,f) Stats_table{f}] = Function(RFPtoThreshold(:,:,:,f),parameters);

    end
    RFP_FTL_max = MAX_proj_3D(RFP_FTL);
    for f=1:size(RFP_FTL_max,3)
        RFP_FTL_RGB(:,:,:,f)=label2rgb(RFP_FTL_max(:,:,f),'jet', 'k', 'shuffle');
    end
    
    if strcmp(show,'on')==1;
        D=zeros(size(RFP_FTL_max,1),size(RFP_FTL_max,2),1,size(RFP_FTL_max,3));
        D(:,:,1,:)=RFP_FTL_max(:,:,:);
        montage(D, [0 1]);
        D(:,:,1,:)=RFP_FTL_max(:,:,:)+1;
        mov = immovie(RFP_FTL_RGB);
        implay(mov)
    end
end