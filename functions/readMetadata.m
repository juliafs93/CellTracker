function[Bits,Width,Height, Channels, Slices, Frames, XRes, YRes, ZRes] = readMetadata(Path, File)
%%
info = imfinfo([Path,File],'tif');
numbers = strsplit(info(1).ImageDescription,'\n');
Bits = info(1).BitDepth;
Width = info(1).Width;
Height = info(1).Height;
try
XRes = 0;
YRes = 0;
XRes = 1/info(1).XResolution;
YRes = 1/info(1).YResolution;
end
if Bits==16
    Bits=12
end

%%
metadata = cell(size(numbers,2),2);
for x=1:size(numbers,2)
    metadata(x,:)=strsplit(char(numbers(x)),'=');
end
%%
Channels = metadata(strcmp(metadata,'channels'),2);
Slices = metadata(strcmp(metadata,'slices'),2);
Frames = metadata(strcmp(metadata,'frames'),2);
try
ZRes=0
ZRes = str2num(metadata{strcmp(metadata,'spacing'),2});
end
if isempty(Channels)==1;
    Channels=1
else
    Channels=str2num(Channels{:})
end

if isempty(Slices)==1;
    Slices=1
else
    Slices=str2num(Slices{:})
end

if isempty(Frames)==1;
    Frames=1
else
    Frames=str2num(Frames{:})
end

end