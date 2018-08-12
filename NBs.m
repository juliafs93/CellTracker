%% Eva's NBs

%% PATH TO WHERE YOU KEEP THE MOVIES AND YOUR GOOGLE DRIVE
%info = readtable('~/Google Drive/MATLAB_R_scripts/metadata_N_for3D.txt','Delimiter','\t')
MetaFile = '~/Google Drive/MATLAB_R_scripts/metadata_NBs_3D.txt';
info = readtable(MetaFile,'Delimiter','\t')

%%
Paths = table2cell(info(:,1))
Files = table2cell(info(:,2))
Names = table2cell(info(:,3))

%%
clearvars('-except', 'Paths','Files','Names','MetaFile');
for x = [1:length(Files)] %missing 3
    %mainNBs(Paths{x}, Files{x}, Names{x},false)
    disp([Paths{x}, Files{x}, Names{x}]);
    mainNBs_3D(MetaFile,Paths{x}, Files{x}, Names{x},false)
    clearvars('-except', 'Paths','Files','Names','MetaFile'); 
end

%% to run all files from a folder (metadata will be added to general metadata file
Path = [uigetdir('/Volumes/Mac OS/NBs'),'/'];
Files = dir([Path,'/*.tif']);
Files = {Files.name};
Names = '_3D/';
MetaFile = '~/Google Drive/MATLAB_R_scripts/metadata_NBs_3D.txt';
clearvars('-except', 'Path','Files','Names','MetaFile');
for x = [1:length(Files)] % error in 15, 20
    %mainNBs(Paths{x}, Files{x}, Names{x},false)
    %try
    disp([Path, Files{x}, Names]);
    mainNBs_3D(MetaFile,Path, Files{x}, Names,false)
    clearvars('-except', 'Path','Files','Names','MetaFile'); 
    %end
end
