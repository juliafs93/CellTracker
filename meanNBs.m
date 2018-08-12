clear all
Metadata = readtable('~/Google Drive jf565/MATLAB_R_scripts/metadata_NBs_3D.txt');
SelectedLacZ = [];
SelectedNact = [];
SelectedNactMi2 = [];

for i = 1:height(Metadata)
    Table2Vars(Metadata(i,:));
    try
        readtable([Path,File,Name,File,'_Fselected.txt']);
        if strcmp(Experiment,'LacZ')
            SelectedLacZ = [SelectedLacZ,i];
        end
        if strcmp(Experiment,'Nact')
            SelectedNact = [SelectedNact,i];
        end
        if strcmp(Experiment,'NactMi2')
            SelectedNactMi2 = [SelectedNactMi2,i];
        end
    end
end

By = 'MeanIntensity'
%By = 'MeanIntensityOld'
%%
NBMeanF = {};
GMCMeanF = {};
GMCNewMeanF = {};
for i = 1:length(SelectedLacZ)
    Table2Vars(Metadata(SelectedLacZ(i),:));
    TableF = readtable([Path,File,Name,File,'_Fselected.txt']);
    Frames = max(TableF.Frame);
    Labels = unique(TableF.NewLabel);
    MeanF = Reshape(TableF,Frames, Labels, By,'NewLabel');
    NBs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'NB')));
    GMCs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'GMC')));
    %GMCsNew = find(cellfun(@(x) ~isempty(x),regexp(Labels,'new')));
    %GMCs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'GMC')) & ~cellfun(@(x) ~isempty(x),regexp(Labels,'new')));end
    for n = 1:length(NBs)
        NBMeanF{end+1} = MeanF(:,NBs(n))
    end
    for n = 1:length(GMCs)
        GMCMeanF{end+1} = MeanF(:,GMCs(n))
    end
%      for n = 1:length(GMCsNew)
%         GMCNewMeanF{end+1} = MeanF(:,GMCsNew(n))
%     end
    % x GMCs from X movies
end
%
GMCAll = nan(600,length(GMCMeanF))
for n = 1:length(GMCMeanF)
    Trace = GMCMeanF{n};
    String = char(join(string(double(~isnan(Trace))),''));
    Index = strfind(String,'1');
    
    GMCAll(1:length(Trace) - Index(1),n) = Trace(Index(1)+1:end);
    
end
LacZGMC = nanmean(GMCAll,2);
LacZGMCSD = nanstd(GMCAll,1,2);
%
NBAll = nan(1000,length(NBMeanF)*2)
for n = 1:length(NBMeanF)
    Trace = NBMeanF{n};
    Diff = diff(medfilt1(Trace,9),1);
    figure; plot(Trace); hold on ; plot(Diff)
    %Downs = find(Diff < -0.15)
    try
    Ups = find(Diff > 0.15) % 5 or 0.15
    CycleLength = diff([Ups;length(Trace)]);
    Ups = Ups(CycleLength > 50);
    CycleLength = diff([Ups;length(Trace)]);
    plot(Ups, 1,'.r', 'MarkerSize',20)
    for c = 1:length(CycleLength)-1
        Cycle = imresize([Trace(Ups(c):Ups(c)+CycleLength(c))],[1000,1]) ; 
        NBAll(1:length(Cycle),end+1) = Cycle;   
    end
    end
    %pause(0.5)
    close all
end
LacZNB = nanmean(NBAll,2);
plot(LacZNB)
%%

NBMeanF = {};
GMCMeanF = {};
GMCNewMeanF = {};
for i = 1:length(SelectedNact)
    Table2Vars(Metadata(SelectedNact(i),:));
    TableF = readtable([Path,File,Name,File,'_Fselected.txt']);
    Frames = max(TableF.Frame);
    Labels = unique(TableF.NewLabel);
    MeanF = Reshape(TableF,Frames, Labels, By,'NewLabel');
    NBs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'NB')));
    %GMCs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'GMC')));
    GMCsNew = find(cellfun(@(x) ~isempty(x),regexp(Labels,'new')));
    GMCs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'GMC')) & ~cellfun(@(x) ~isempty(x),regexp(Labels,'new')));
    for n = 1:length(NBs)
        NBMeanF{end+1} = MeanF(:,NBs(n))
    end
    for n = 1:length(GMCs)
        GMCMeanF{end+1} = MeanF(:,GMCs(n))
    end
    for n = 1:length(GMCsNew)
        GMCNewMeanF{end+1} = MeanF(:,GMCsNew(n))
    end
    % x GMCs from X movies
end
%
GMCAll = nan(600,length(GMCMeanF))
for n = 1:length(GMCMeanF)
    Trace = GMCMeanF{n};
    String = char(join(string(double(~isnan(Trace))),''));
    Index = strfind(String,'1');  
    GMCAll(1:length(Trace) - Index(1),n) = Trace(Index(1)+1:end); 
end

GMCNewAll = nan(600,length(GMCNewMeanF))
for n = 1:length(GMCNewMeanF)
    Trace = GMCNewMeanF{n};
    String = char(join(string(double(~isnan(Trace))),''));
    Index = strfind(String,'1');
    
    GMCNewAll(1:length(Trace) - Index(1),n) = Trace(Index(1)+1:end);
    
end
NactGMC = nanmean(GMCAll,2);
NactGMCSD = nanstd(GMCAll,1,2);

NactGMCNew = nanmean(GMCNewAll,2);
NactGMCNewSD = nanstd(GMCNewAll,1,2);
%

NBAll = nan(1000,1)
for n = 1:length(NBMeanF)
    Trace = NBMeanF{n};
    Diff = diff(medfilt1(Trace,9),1);
    figure; plot(Trace); hold on ; plot(Diff)
    %Downs = find(Diff < -0.15)
    try
    Ups = find(Diff > 0.15)
    CycleLength = diff([Ups;length(Trace)]);
    Ups = Ups(CycleLength > 50);
    CycleLength = diff([Ups;length(Trace)]);
    plot(Ups, 1,'.r', 'MarkerSize',20)
    for c = 1:length(CycleLength)-1
        Cycle = imresize([Trace(Ups(c):Ups(c)+CycleLength(c))],[1000,1]) ; 
        NBAll(1:length(Cycle),end+1) = Cycle;   
    end
    end
    %pause(0.5)
    close all
end
NactNB = nanmean(NBAll,2);
plot(NactNB)


%%
NBMeanF = {};
GMCMeanF = {};
GMCNewMeanF = {};
for i = 1:length(SelectedNactMi2)
    Table2Vars(Metadata(SelectedNactMi2(i),:));
    TableF = readtable([Path,File,Name,File,'_Fselected.txt']);
    Frames = max(TableF.Frame);
    Labels = unique(TableF.NewLabel);
    MeanF = Reshape(TableF,Frames, Labels, By,'NewLabel');
    NBs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'NB')));
    GMCs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'GMC')));
    %GMCsNew = find(cellfun(@(x) ~isempty(x),regexp(Labels,'new')));
    %GMCs = find(cellfun(@(x) ~isempty(x),regexp(Labels,'GMC')) & ~cellfun(@(x) ~isempty(x),regexp(Labels,'new')));end
    for n = 1:length(NBs)
        NBMeanF{end+1} = MeanF(:,NBs(n))
    end
    for n = 1:length(GMCs)
        GMCMeanF{end+1} = MeanF(:,GMCs(n))
    end
%      for n = 1:length(GMCsNew)
%         GMCNewMeanF{end+1} = MeanF(:,GMCsNew(n))
%     end
    % x GMCs from X movies
end
%
GMCAll = nan(600,length(GMCMeanF))
for n = 1:length(GMCMeanF)
    Trace = GMCMeanF{n};
    String = char(join(string(double(~isnan(Trace))),''));
    Index = strfind(String,'1');
    
    GMCAll(1:length(Trace) - Index(1),n) = Trace(Index(1)+1:end);
    
end
NactMi2GMC = nanmean(GMCAll,2);
NactMi2GMCSD = nanstd(GMCAll,1,2);

NBAll = nan(1000,length(NBMeanF)*2)
for n = 1:length(NBMeanF)
    Trace = NBMeanF{n};
    Diff = diff(medfilt1(Trace,9),1);
    figure; plot(Trace); hold on ; plot(Diff)
    %Downs = find(Diff < -0.15)
    try
    Ups = find(Diff > 0.15)
    CycleLength = diff([Ups;length(Trace)]);
    Ups = Ups(CycleLength > 50);
    CycleLength = diff([Ups;length(Trace)]);
    plot(Ups, 1,'.r', 'MarkerSize',20)
    for c = 1:length(CycleLength)-1
        Cycle = imresize([Trace(Ups(c):Ups(c)+CycleLength(c))],[1000,1]) ; 
        NBAll(1:length(Cycle),end+1) = Cycle;   
    end
    end
    %pause(0.5)
    close all
end
NactMi2NB = nanmean(NBAll,2);
plot(NactMi2NB)

%%

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/GMCs eva SD.pdf']
    Fig = figure('PaperSize',[30 30],'PaperUnits','inches','resize','on', 'visible','on');

errorbar([1:length(LacZGMC)],LacZGMC,LacZGMCSD,LacZGMCSD,'.-','MarkerSize',12,'LineWidth',0.1,'DisplayName','LacZ'); hold on
errorbar([1:length(NactGMCNew)],NactGMCNew,NactGMCNewSD,NactGMCNewSD,'.-','MarkerSize',12,'LineWidth',0.1,'DisplayName','Nact newGMC')
errorbar([1:length(NactGMC)],NactGMC,NactGMCSD,NactGMCSD,'.-','MarkerSize',12,'LineWidth',0.1,'DisplayName','Nact oldGMC')
errorbar([1:length(NactMi2GMC)],NactMi2GMC,NactMi2GMCSD,NactMi2GMCSD,'.-','MarkerSize',12,'LineWidth',0.1,'DisplayName','Nact Mi2')

xlabel('Time after mitosis (min)')
ylabel('Relative mean fluorescence (AU)')
xlim([0,300])
legend boxoff
box off
print(Fig,FileOut,'-fillpage','-dpdf');
%%

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/GMCs eva new.pdf']
    Fig = figure('PaperSize',[30 30],'PaperUnits','inches','resize','on', 'visible','on');

plot([1:length(LacZGMC)],LacZGMC,'.-','MarkerSize',12,'DisplayName','LacZ'); hold on
plot([1:length(NactGMCNew)],NactGMCNew,'.-','MarkerSize',12,'DisplayName','Nact newGMC')
%plot([1:length(NactGMC)],NactGMC,'.-','MarkerSize',12,'DisplayName','Nact oldGMC')
plot([1:length(NactMi2GMC)],NactMi2GMC,'.-','MarkerSize',12,'DisplayName','Nact Mi2')
xlabel('Time after mitosis (min)')
ylabel('Relative mean fluorescence (AU)')
xlim([0,300])
%ylim([0.4,1.6])
legend boxoff
box off
print(Fig,FileOut,'-fillpage','-dpdf');
%%

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/GMCs eva norm new.pdf']
    Fig = figure('PaperSize',[30 30],'PaperUnits','inches','resize','on', 'visible','on');

plot([1:length(LacZGMC)],LacZGMC./LacZGMC(1),'.-','MarkerSize',12,'DisplayName','LacZ'); hold on
plot([1:length(NactGMCNew)],NactGMCNew./NactGMCNew(1),'.-','MarkerSize',12,'DisplayName','Nact newGMC')
%plot([1:length(NactGMC)],NactGMC./NactGMC(1),'.-','MarkerSize',12,'DisplayName','Nact oldGMC')
plot([1:length(NactMi2GMC)],NactMi2GMC./NactMi2GMC(1),'.-','MarkerSize',12,'DisplayName','Nact Mi2')
xlabel('Time after mitosis (min)')
ylabel('Relative mean fluorescence (AU)')
xlim([0,300])
%ylim([0.4,1.6])
legend boxoff
box off
print(Fig,FileOut,'-fillpage','-dpdf');

%%
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/NBs eva norm.pdf']
    Fig = figure('PaperSize',[30 30],'PaperUnits','inches','resize','on', 'visible','on');

plot([1:length(LacZNB)]./10,LacZNB./LacZNB(1),'.-','MarkerSize',12,'DisplayName','LacZ'); hold on
plot([1:length(NactNB)]./10,NactNB./NactNB(1),'.-','MarkerSize',12,'DisplayName','Nact')
plot([1:length(NactMi2NB)]./10,NactMi2NB./NactMi2NB(1),'.-','MarkerSize',12,'DisplayName','Nact Mi2')
xlabel('% cell cycle')
ylabel('Relative mean fluorescence (AU)')
xlim([0,100])
%ylim([0.4,1.6])
legend boxoff
box off
print(Fig,FileOut,'-fillpage','-dpdf');
%%
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/NBs eva.pdf']
    Fig = figure('PaperSize',[30 30],'PaperUnits','inches','resize','on', 'visible','on');

plot([1:length(LacZNB)]./10,LacZNB,'.-','MarkerSize',12,'DisplayName','LacZ'); hold on
plot([1:length(NactNB)]./10,NactNB,'.-','MarkerSize',12,'DisplayName','Nact')
plot([1:length(NactMi2NB)]./10,NactMi2NB,'.-','MarkerSize',12,'DisplayName','Nact Mi2')
xlabel('% cell cycle')
ylabel('Relative mean fluorescence (AU)')
xlim([0,100])
%ylim([0.4,1.6])
legend boxoff
box off
print(Fig,FileOut,'-fillpage','-dpdf');
