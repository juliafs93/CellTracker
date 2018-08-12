function[]=mainNBs(Path,File,Name,manual)
%% FIRST DO manual = true  IF RUNNING SCRIPT MANUALLY
if manual == true
    clear all
    [File,Path] = uigetfile('*.tif');
    Name = '_Notch_18/' % CHANGE NICKNAME HERE
    mkdir([Path,File,Name])
    show = 'on'
else
    show = 'off'
end
%%
mkdir([Path,File,Name])

try %reads parameters file and imports previous parameters
    Parameters = readtable([Path,File,Name,File,'_parameters.txt']);
    for x = [1:length(Parameters.Properties.VariableNames)]
        command = strcat(char(Parameters.Properties.VariableNames(x)), ' = ', num2str(Parameters.(x)));
        eval(command)
    end
    skip = true %dont change

    %MaxN = 10 %here add parameters that you want to change globally when
    %mainNBs is run as function in all datasets
catch
    % if no parameter file, set them here
    % Z0 and Zf are slices used for max projection and F measurements, so
    % far always used all of them
    % Z0toSeg and ZftoSeg are the slices used for segmentation and tracking
    % (will do the max projection of Red and Green channels and add them,
    % so choose slices in which both R and G signals are strong but dont
    % overlap too much when projecting)
    disp('couldnt read parameters, set them below (press any key to continue)')
    pause
    [Bits, Width,Height, Channels, SlicesO, FramesO] = readMetadata(Path, File)
    Y0 = 240 % Y start, pixels, default 1
    Yf = 374 % Y end, pixels, default Heigth
    X0 = 210 % X start, pixels, default 1
    Xf = 363 % X end, pixels, default Width
    Z0 = 1 % Z start, pixels, default 1
    Zf = SlicesO % Z end, pixels, default Slices
    T0 = 1 % T start, frame, default 1
    Tf = FramesO %T end, frame, default Frames
    Z0toSeg = 2 % Z start for segmentation, pixels, default 1
    ZftoSeg = 7 % Z start for segmentation, pixels,default Frames
    skip = false %dont change
end
%%
% try
%     [RFP_FTL_tracked mG_max] = readOld(Path,File,Name);
%     %[RFP_FTL_tracked] = readOld(Path, Files{x}, names{x});
%     load([Path,File,Name,File,'_Stats.mat'],'Stats_table','Stats_tracked','Stats_GFP');
%     %load([Path, Files{x}, names{x},Files{x},'_Stats.mat'],'Stats_table','Stats_tracked','Stats_GFP')
%     disp('tracked, GFP_max and Stats loaded from previous run')
%     disp('going directly to GFP measuring')
% catch
    %% read and crop 5D stack
    A = Read5d([Path,File], Channels, SlicesO, FramesO);
    disp('read 5d')
    B = A(Y0:Yf, X0:Xf,:,Z0:Zf,T0:Tf);
    Frames = size(B,5)
    Slices = size(B,4)
    clear A

    %% read channels
    hisRFP = MAX_proj(B, 1,Frames, 1,Slices,2);
    mG_max = MAX_proj(B, 1,Frames, 1,Slices,1);
    %grey = MAX_proj(B, 1,Frames, 1,Slices,3);
    %% parameters for thresholding and tracking
    if skip == false;
        % for thresholding
        SigmaFilt = 2 %2-3
        InputLow = 0.2 %0.2
        InputHigh = 0.35 %0.4
        WatershedParameter = 3.5 %when higher less watershed, when lower more watershed
        DiskSize = 3
        Remove1 = 30
        Remove2 = 50
        % for tracking
        Distance = 10
        MaxN = 10
    end
    %% threshold
    RFPtoThreshold=MAX_proj(B, 1,Frames, Z0toSeg,ZftoSeg,2) + MAX_proj(B, 1,Frames,Z0toSeg,ZftoSeg,1);
    [RFPtoThreshold3] = Contrast(RFPtoThreshold, InputLow, InputHigh,SigmaFilt,show);
    [RFP_FTL RFP_FTL_RGB Stats_table] = SegmentNuc(RFPtoThreshold3, @ThresLabNBs, num2cell([Remove1 DiskSize WatershedParameter Remove2]),show);
    %% tracking
    cmap = jet(1000);
    cmap_shuffled = cmap(randperm(size(cmap,1)),:);
    [RFP_FTL_tracked RFP_FTL_tracked_RGB Stats_tracked] = Tracking(RFP_FTL, Stats_table, cmap_shuffled, Distance,MaxN,'on',show);
%end
%% measure and save F, save movies by F levels
[Stats_GFP MaxF MinF] = getStatsF(RFP_FTL_tracked, mG_max);
[Stats_GFP] = printF(Stats_GFP,Path,File,Name,'off');
[RFP_FTL_tracked_meanF] = replaceLabelsbyF(RFP_FTL_tracked, Stats_GFP, MinF,MaxF,'MeanIntensity');
[RFP_boundariesBW RFP_boundariesL RFP_boundaries_RGB] = BoundariesTracked(RFP_FTL_tracked,cmap_shuffled,show);
RFP_FTL_tracked_meanF_noB = ~RFP_boundariesBW.*RFP_FTL_tracked_meanF;
[RFP_FTL_tracked_meanF_boundaries] = Merge8bRGB(RFP_FTL_tracked_meanF_noB, RFP_boundaries_RGB,show);
[RFP_FTL_tracked_RGB_info Movie] = printLabels(RFP_FTL_tracked_meanF_boundaries, Stats_tracked,show);

%% save all images and parameters
imwrite(RFP_FTL_tracked_RGB(:,:,:,1),jet, [Path,File,Name,File, '_segmented_tracked.tiff'],'Compression','none')
for f = 2:size(RFP_FTL_tracked,3)
    imwrite(RFP_FTL_tracked_RGB(:,:,:,f),jet, [Path,File,Name,File, '_segmented_tracked.tiff'],'WriteMode','append','Compression','none')
end

imwrite(uint16(RFP_FTL_tracked(:,:,1)), [Path,File,Name,File, '_segmented_tracked_16.tiff'],'Compression','none')
for f = 2:size(RFP_FTL_tracked,3)
    imwrite(uint16(RFP_FTL_tracked(:,:,f)), [Path,File,Name,File, '_segmented_tracked_16.tiff'],'WriteMode','append','Compression','none')
end

imwrite(RFP_boundaries_RGB(:,:,:,1),jet, [Path,File,Name,File, '_segmented_tracked_boundaries_RGB.tiff'],'Compression','none')
for f = 2:size(RFP_boundaries_RGB,4)
    imwrite(RFP_boundaries_RGB(:,:,:,f),jet, [Path,File,Name,File, '_segmented_tracked_boundaries_RGB.tiff'],'WriteMode','append','Compression','none')
end


imwrite(RFP_FTL_tracked_RGB_info(:,:,:,1),jet, [Path,File,Name,File, '_segmented_tracked_info.tiff'],'Compression','none')
for f = 2:size(RFP_FTL_tracked,3)
    imwrite(RFP_FTL_tracked_RGB_info(:,:,:,f),jet, [Path,File,Name,File, '_segmented_tracked_info.tiff'],'WriteMode','append','Compression','none')
end

imwrite(uint8(RFP_FTL_tracked_meanF(:,:,1)), [Path,File,Name,File, '_segmented_tracked_8F.tiff'],'Compression','none')
for f = 2:size(RFP_FTL_tracked_meanF,3)
    imwrite(uint8(RFP_FTL_tracked_meanF(:,:,f)), [Path,File,Name,File, '_segmented_tracked_8F.tiff'],'WriteMode','append','Compression','none')
end

imwrite(uint16(mG_max(:,:,1)), [Path,File,Name,File, '_max_GFP.tiff'],'Compression','none')
for f = 2:size(mG_max,3)
    imwrite(uint16(mG_max(:,:,f)), [Path,File,Name,File, '_max_GFP.tiff'],'WriteMode','append','Compression','none')
end

parameters = table(Bits,Channels, SlicesO, FramesO,Slices, Frames,Width,Height, X0,Xf,Y0,Yf,Z0,Zf,T0,Tf,Z0toSeg,ZftoSeg,SigmaFilt,InputLow,InputHigh,WatershedParameter,DiskSize,Remove1,Remove2,Distance,MaxN);
writetable(parameters,[Path,File,Name,File,'_parameters.txt']);
save([Path,File,Name,File,'_Stats.mat'],'Stats_table','Stats_tracked','Stats_GFP')

Metadata = readtable('~/Google Drive/MATLAB_R_scripts/metadata.txt','Delimiter', '\t');
NewMetadata = cell2table({File,Name,Frames},'VariableNames', {'File','Name','Frames'});
SaveMetadata = [Metadata;NewMetadata];
writetable(SaveMetadata,'~/Google Drive/MATLAB_R_scripts/metadata.txt','Delimiter', '\t');

disp('done')

end