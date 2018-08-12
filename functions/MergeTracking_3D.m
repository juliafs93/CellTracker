function [RFP_FTL_tracked RFP_FTL_tracked_RGB ] = MergeTracking_3D(RFP_FTL_tracked, Stats_new, cmap)
    for f=1:size(RFP_FTL_tracked,3)
        %f=220
        disp(['frame ',num2str(f)])
        StatsT = Stats_new{f};
        StatsT.Label = (1:length(StatsT.Area))';
        toremove = find(StatsT.Area==0);
        StatsT(toremove,:)= [];

        F_t=zeros(size(RFP_FTL_tracked,1),size(RFP_FTL_tracked,2),length(StatsT.Label));
        for x=[StatsT.Label]'
            index=find(StatsT.Label==x);
            nuc_im=StatsT.Image{index};
            nuc_bridge = bwmorph(nuc_im,'bridge',Inf);
            nuc_filled = imfill(nuc_bridge,'holes');
            %box = StatsT.BoundingBox(index,:);
            idx = StatsT.SubarrayIdx(index,:);
            F_t(idx{:},index)= nuc_filled.*x(:);
        end
        try
            RFP_FTL_tracked(:,:,f)=max(F_t,[],3);
            RFP_FTL_tracked_RGB(:,:,:,f) = label2rgb(RFP_FTL_tracked(:,:,f), cmap, 'k', 'noshuffle');
        end
    end