function[RFP_FTL_tracked] = ReplaceLabelsbyF_3D(RFP_FTL_tracked, Stats_GFP_table,minF,maxF,by)
%RFP_FTL_tracked_meanF = RFP_FTL_tracked;
for f = 1:size(RFP_FTL_tracked,4)
    toreplace = RFP_FTL_tracked(:,:,:,f);
    Table = Stats_GFP_table{f};
    for x = 1:length(Stats_GFP_table{f}.Label);
        toreplace(Stats_GFP_table{f}.PixelIdxList{x}) = round((Table{x,by}-minF+1)/(maxF-minF+1)*255);
        %toreplace(Table{x,'PixelIdxList'}) = round((Table{x,by}-minF+1)/(maxF-minF+1)*255);
    end
    RFP_FTL_tracked(:,:,:,f) = toreplace;

end