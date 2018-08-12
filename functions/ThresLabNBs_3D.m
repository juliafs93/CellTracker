function [TL Stats_table] = ThresLabNBs_3D(toThreshold,parameters,varargin)
        [remove1 diskSize WatershedParameter remove2 Level Thicken] = parameters{:};
        %level = graythresh(toThreshold);
        T = zeros(size(toThreshold));
        mask=T(:,:,1);
        mask(2:size(mask,1)-1,2:size(mask,2)-1)=1;
        for z=1:size(toThreshold,3)
            BW=imbinarize(toThreshold(:,:,z),Level);
            T(:,:,z)=activecontour(BW,mask,100);  
        end
        %T = imregionalmax(toThreshold,4);
        Tf = imfill(T, 'holes');
        Tfar = bwareaopen(Tf,remove1,6);
        %se = strel('disk',10); %movie1
        %se = strel('disk',5); %movie2
        %se = strel('sphere',diskSize); %movie3=3
        %TfarO = imopen(Tfar, se);
        %[dummy L] = bwboundaries(TfarO, 4, 'noholes');
        %L=bwlabel(TfarT,4);
        %Le = imdilate(L,se);
        
        if isnan(WatershedParameter)~=1
            try
                Voxel = varargin{1};
                D = bwdistsc(~Tfar,Voxel);
            catch
                D = bwdist(~Tfar);
            end
            D = -D;
            %D(~L) = -Inf;
            D2 = imhmin(D,WatershedParameter);
            %D2=D;
            D2(~Tfar) = -Inf;
            L2 = watershed(D2, 18);
            L3 = bwareaopen(L2-1,remove2,6);
        else
            L3 = Tfar;
        end
        if Thicken~=0
            for z=1:size(toThreshold,3)
                L4(:,:,z) = bwmorph(L3(:,:,z),'thicken',Thicken);
            end
            TL = bwlabeln(L4,6);
        else
            TL = bwlabeln(L3,6);
        end
        %TL = L5;
        %TL_RGB=label2rgb(TL,'jet', 'k', 'shuffle');
        %Stats{f,1} = regionprops(RFP_FTL(:,:,f),'Area','Centroid','Perimeter','Image','SubarrayIdx');
        Stats_table = regionprops('table',TL,'Area','Centroid','SubarrayIdx');

end