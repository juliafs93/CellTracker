function[Stats_GFP] = PrintF_3D(varargin)
    Stats_GFP = varargin{1};
    Path = varargin{2};
    File = varargin{3};
    Name = varargin{4};
    Spots = varargin{5};
    for f = 1:size(Stats_GFP,1)
        %Stats_GFP_table = struct2table(Stats_GFP{f,1});
        Stats_GFP_table = Stats_GFP{f,1};
        Stats_GFP_table.Label = (1:length(Stats_GFP_table.MeanIntensity))';
        toremove = isnan(table2array(Stats_GFP_table(:,'MeanIntensity')));
        Stats_GFP_table(toremove,:)= [];
        disp(['f',num2str(f)])
        Stats_GFP_table.Max = nan(size(Stats_GFP_table,1),1);
        Stats_GFP_table.SpotPositionX = nan(size(Stats_GFP_table,1),1);
        Stats_GFP_table.SpotPositionY = nan(size(Stats_GFP_table,1),1);
        Stats_GFP_table.SpotPositionZ = nan(size(Stats_GFP_table,1),1);
        if Spots == 2
            Stats_GFP_table.Max2 = nan(size(Stats_GFP_table,1),1);
            Stats_GFP_table.Spot2PositionX = nan(size(Stats_GFP_table,1),1);
            Stats_GFP_table.Spot2PositionY = nan(size(Stats_GFP_table,1),1);
            Stats_GFP_table.Spot2PositionZ = nan(size(Stats_GFP_table,1),1);
        end
        for Label = [Stats_GFP_table.Label]'
            index = find(Stats_GFP_table.Label==Label);
            %Idx = Stats_GFP_table.PixelIdxList{index,1};
            
            List = Stats_GFP_table.PixelList{index,1};
            Values = Stats_GFP_table.PixelValues{index,1};
            Sorted = sort(Values);
            if Spots == 0
                Max = max(Sorted);
                Which = find([Values']==Max);
                if size(Which,2)>1
                    Which=Which(1,1);
                end
                SpotPosition = List(Which,:);
                Stats_GFP_table.Max(index,1) = max(Values);
                Stats_GFP_table.SpotPositionX(index,1) = SpotPosition(1);
                Stats_GFP_table.SpotPositionY(index,1) = SpotPosition(2);
                Stats_GFP_table.SpotPositionZ(index,1) = SpotPosition(3);

            end
          
            if Spots ~= 0
                Unique = sort(unique(Values(Values ~= 0)));
                if length(Unique) > 0
                     Which1 = find([Values']==Unique(1));
                     SpotPosition1 = List(Which1,:);
                     Stats_GFP_table.Max(index,1) = Unique(1);
                     Stats_GFP_table.SpotPositionX(index,1) = SpotPosition1(1);
                     Stats_GFP_table.SpotPositionY(index,1) = SpotPosition1(2);
                     Stats_GFP_table.SpotPositionZ(index,1) = SpotPosition1(3);
                     if length(Unique) > 1 & Spots == 2
                         Which2 = find([Values']==Unique(2));
                         SpotPosition2 = List(Which2,:);
                         Stats_GFP_table.Max2(index,1) = Unique(2);
                         Stats_GFP_table.Spot2PositionX(index,1) = SpotPosition2(1);
                         Stats_GFP_table.Spot2PositionY(index,1) = SpotPosition2(2);
                         Stats_GFP_table.Spot2PositionZ(index,1) = SpotPosition2(3);
                    end
                end
            end
        end
        %try
            toPrint = Stats_GFP_table(:,[1 2 6:size(Stats_GFP_table,2)]);
            Stats_GFP_table.PixelList = [];
            Stats_GFP_table.PixelValues = [];
            Stats_GFP_table.MaxIntensity = [];
            %Stats_GFP_table.PixelIdxList = [];%dont remove, needed for
            %ReplaceF
            Stats_GFP{f,1} = Stats_GFP_table;  
            try
                Print = varargin{6};
                if Print ~= 0; f = Print; end
                mkdir([Path,File,Name,'F/'])
                writetable(toPrint,[Path,File,Name,'F/','frame',num2str(f),'.txt']);
            end
        %end
    end
end
