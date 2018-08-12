function [BoundariesBW Boundaries_RGB Boundaries1_RGB] = BoundariesTracked_3D(FTL_tracked,cmap,show)
    Boundaries_RGB = zeros(size(FTL_tracked,1),size(FTL_tracked,2),3,size(FTL_tracked,4));
    Boundaries1_RGB = zeros(size(FTL_tracked,1),size(FTL_tracked,2),3,size(FTL_tracked,4));
    BoundariesBW = zeros(size(FTL_tracked,1),size(FTL_tracked,2),size(FTL_tracked,4));
    Boundaries1L = zeros(size(FTL_tracked,1),size(FTL_tracked,2),size(FTL_tracked,4));
    BoundariesL = zeros(size(FTL_tracked,1),size(FTL_tracked,2),size(FTL_tracked,4));
    boundariesBW = zeros(size(FTL_tracked,1),size(FTL_tracked,2),size(FTL_tracked,3));
    boundariesL = zeros(size(FTL_tracked,1),size(FTL_tracked,2),size(FTL_tracked,3));
    for f=1:size(FTL_tracked,4);
        disp(['f', num2str(f)]);
        T3D = FTL_tracked(:,:,:,f);
        BoundariesBW(:,:,f) = bwmorph(MAX_proj_3D(T3D),'remove');
        Boundaries1L(:,:,f) = BoundariesBW(:,:,f).*MAX_proj_3D(T3D);
        for z = 1:size(FTL_tracked,3);
            boundariesBW(:,:,z) = bwmorph(T3D(:,:,z),'remove');
            boundariesL(:,:,z) = boundariesBW(:,:,z).*T3D(:,:,z);
        end
        BoundariesL(:,:,f) = MAX_proj_3D(boundariesL);
        Boundaries_RGB(:,:,:,f) = label2rgb(BoundariesL(:,:,f), cmap, 'k', 'noshuffle');
        Boundaries1_RGB(:,:,:,f) = label2rgb(Boundaries1L(:,:,f), cmap, 'k', 'noshuffle');
    end

    if strcmp(show,'on')==1;
            %D=zeros(size(RFP_b_max,1),size(RFP_b_max,2),1,size(RFP_b_max,3));
            %D(:,:,1,:)=RFP_b_max(:,:,:);
            %montage(D, [0 1]);
            %D(:,:,1,:)=RFP_b_max(:,:,:)+1;
            mov = immovie(Boundaries_RGB);
            implay(mov)
    end

end