function [FTL FTL_tracked_RGB Stats_new] = Tracking_3D(FTL, Stats_new, cmap, distance,N,Divisions,merge,show)
    FTL_tracked_RGB = zeros(size(FTL,1),size(FTL,2),3,size(FTL,3));
    F0_t_RGB = label2rgb(max(FTL(:,:,:,1),[],3), cmap, 'k', 'noshuffle');
    FTL_tracked_RGB(:,:,:,1) = F0_t_RGB(:,:,:);
    newLabel=max(max(max(max(FTL(:,:,:,:)))))+1;
    Stats_new{1,:}.Label = (1:size(Stats_new{1,:},1))';
    if Divisions
            Stats_new{1,:}.Parent = zeros(size(Stats_new{1,:},1),1);
            Stats_new{1,:}.Daughters = zeros(size(Stats_new{1,:},1),2);
    end
    toReplace = Stats_new{1,:}(1,:); 
    for r = 1:size(toReplace,2); try; toReplace(1,r) = table(NaN);end; end
        
    for f=2:size(FTL,4)

        disp(['frame ',num2str(f-1),' to ',num2str(f)])
        F1_0 = FTL(:,:,:,f);
        F1_t = zeros(size(FTL(:,:,:,f)));
        From = f-N;
        if From < 1;
            From = 1;
        end
        SubStats = Stats_new(From:f,1);
        % XYRes and ZRes = 1 so that min distance is still pixels
        %[F1_t F1_t_RGB SubStats newLabel] = Tracknextframe4_3D(SubStats,F1_0,F1_t, cmap,f,distance,newLabel,N,1,1);  %for others   
        [F1_t F1_t_RGB SubStats newLabel] = TrackWithDivisions_3D(SubStats,F1_0,F1_t, cmap,f,distance,newLabel,N,Divisions, toReplace, 1,1);  %for others   
        %[F1_t F1_t_RGB SubStats newLabel] = TrackWithDivisions_3D(SubStats,F1_0,F1_t, cmap,f,distance,newLabel,N,Divisions,toReplace);  %for others   
        FTL(:,:,:,f) = F1_t(:,:,:);
        FTL_tracked_RGB(:,:,:,f) = F1_t_RGB(:,:,:);
        Stats_new(From:f,1) = SubStats;
        
    end
    
    if strcmp(merge,'on') == 1;
        [FTL FTL_tracked_RGB ] = MergeTracking_3D(FTL, Stats_new, cmap);
    end  
    if strcmp(show,'on')==1;
        FTL_tracked_max = MAX_proj_3D(FTL);
        D=zeros(size(FTL_tracked_max,1),size(FTL_tracked_max,2),1,size(FTL_tracked_max,3));
        D(:,:,1,:)=FTL_tracked_max(:,:,:);
        montage(D, [0 1]);
        D(:,:,1,:)=FTL_tracked_max(:,:,:)+1;
        mov = immovie(FTL_tracked_RGB);
        implay(mov)
    end

end