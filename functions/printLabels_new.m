function[] = printLabels_new(ToShowRGB,Stats_new,Factor,Visible, PathToSave, Suffix,Compression)
    %RFP_FTL can be labelled in colors (RGB), 8/16 bits or mod with F
    %levels (RFP_FTL_tracked_meanF)
    %RFP_FTL_tracked_RGB_info = zeros(size(ToShowRGB,1)*2,size(ToShowRGB,2)*2,size(ToShowRGB,3),size(ToShowRGB,4));
    %F(size(ToShowRGB,4)) = struct('cdata',[],'colormap',[]);
    fig1=figure; axis([0 size(ToShowRGB(:,:,1),2)*Factor 0 size(ToShowRGB(:,:,1),1)*Factor]);
    set(gca, 'XAxisLocation','top','YAxisLocation','left','ydir','reverse','XTickLabel','','YTickLabel','','Box', 'off');
    set(gcf,'units','pixels','Resize','off','visible',Visible,'position',[0 0 size(ToShowRGB(:,:,1),2)*Factor size(ToShowRGB(:,:,1),1)*Factor]);
    for f=1:size(ToShowRGB,4)
    %for f=1:10
        disp(['frame ',num2str(f)])
        I = mat2gray(ToShowRGB(:,:,:,f));
        [X,map] = gray2ind(I,256);
        imshow(X,map); hold on
        try
            plot(Stats_new{f,1}.Centroid(:,1),Stats_new{f,1}.Centroid(:,2),'.','color','blue','MarkerSize',3*Factor); 
            text(Stats_new{f,1}.Centroid(:,1),Stats_new{f,1}.Centroid(:,2),num2str(Stats_new{f,1}.Label), 'FontSize',5*Factor,'color','white'); 
        end
        set(gca, 'XAxisLocation','top','YAxisLocation','left','ydir','reverse','XTickLabel','','YTickLabel','');
        set(gcf,'units','pixels','Resize','off','visible',Visible,'position',[0 0 size(ToShowRGB(:,:,1),2)*Factor size(ToShowRGB(:,:,1),1)*Factor]);
        %truesize(fig1,[size(ToShowRGB(:,:,1)*2 size(ToShowRGB(:,:,1)*2])
        F=getframe;
        %RFP_FTL_tracked_RGB_info(:,:,:,f) = frame2im(F(f)); 
        hold off;
        if f==1
        imwrite(frame2im(F),jet, [PathToSave, Suffix],'Compression',Compression);
        else
        imwrite(frame2im(F),jet, [PathToSave, Suffix],'WriteMode','append','Compression',Compression);
        end

    end
    close all
    
end