function[F1_t F1_t_RGB SubStats newLabel] = TrackWithDivisions_3D(SubStats,F1_0,F1_t,cmap,f,distance,newLabel,N, Divisions,toReplace,XYRes, ZRes) 
        N = size(SubStats,1)-1;
        Stats0 = SubStats{N,1};
        Stats1 = SubStats{N+1,1};
        %Stats0 = standardizeMissing(Stats0,0,'DataVariables','Centroid');
        %Stats1 = standardizeMissing(Stats1,0,'DataVariables','Centroid');

        Stats1.Label = (1:size(Stats1,1))';
        %toremove = table2array(Stats1(:,'Area'))>50000;
        %Stats1(toremove,:)= [];
        
        if Divisions
            Stats1.Parent = zeros(size(Stats1,1),1);
            Stats1.Daughters = zeros(size(Stats1,1),2);
        end
        Stats1t = Stats1;
        %toReplace = Stats1t(1,:); 
        %for r = 1:size(toReplace,2); try; toReplace(1,r) = table(NaN);end; end
        for i = 1:size(Stats1t,1);Stats1t(i,:) = toReplace;end
        
    for x=[Stats1.Label]'
        try
            index = find(Stats1.Label==x);
            eucledian = sqrt(((Stats0.Centroid(:,1)-Stats1.Centroid(index,1)).*XYRes).^2.+((Stats0.Centroid(:,2)-Stats1.Centroid(index,2)).*XYRes).^2.+((Stats0.Centroid(:,3)-Stats1.Centroid(index,3)).*ZRes).^2);
            closest_index = find(eucledian==min(eucledian));
            closest = Stats0.Label(closest_index);
            if length(closest_index)>1
                    closest_index = closest_index(1);
                    closest = closest(1);
            end
        catch
            eucledian = 100;
            disp(['Frame ',num2str(f-1),' has no objects'])
        end
        
        
        if min(eucledian)<distance
            if Divisions
                [F1_t,Stats0,Stats1t,newLabel] = CheckSisters(F1_0,F1_t,x,closest,closest_index,Stats0,Stats1,Stats1t,newLabel,f);
            else
                subs = find(F1_0==x);
                F1_t(subs)=closest;
                Temp=Stats1(x,:);
                %Stats1t(x,:)= toReplace;
                Stats1t(closest_index,:)=Temp;
                Stats1t{closest_index,'Label'}=closest;
                Stats1t = standardizeMissing(Stats1t,0,'DataVariables','Centroid');
            end
        else
            n = 2;
            skip = false;
            while n <= N & skip == false;
                try
                    disp(['trying N',num2str(n)])
                    Stats_1 = SubStats{N-n+1,1};
                    %Stats_1.Label = (1:size(Stats_1,1))';
                    %toremove = table2array(Stats_1(:,'Area'))>5000;
                    %Stats_1(toremove,:)= [];
                    eucledian = sqrt(((Stats_1.Centroid(:,1)-Stats1.Centroid(index,1)).*XYRes).^2.+((Stats_1.Centroid(:,2)-Stats1.Centroid(index,2)).*XYRes).^2.+((Stats_1.Centroid(:,3)-Stats1.Centroid(index,3)).*ZRes).^2);
                    closest_index = find(eucledian==min(eucledian));
                    closest = Stats_1.Label(closest_index);
                    if length(closest_index)>1
                        closest_index = closest_index(1);
                        closest = closest(1);
                    end
                end
                if min(eucledian)<distance
                    if Divisions
                        [F1_t,Stats_1,Stats1t,newLabel] = CheckSisters(F1_0,F1_t,x,closest,closest_index,Stats_1,Stats1,Stats1t,newLabel,f);
                        SubStats{N-n+1,1} = Stats_1;
                    else
                        subs = find(F1_0==x);
                        F1_t(subs)=closest;
                        Temp=Stats1(x,:);
                        %Stats1t(x,:)= toReplace;
                        Stats1t(closest_index,:)=Temp;
                        Stats1t{closest_index,'Label'}=closest;
                        Stats1t = standardizeMissing(Stats1t,0,'DataVariables','Centroid');
                    end    
                    skip = true;
                    break
                else
                    n=n+1;
                end
            end
            if newLabel ~= NaN & skip == false;
                subs = find(F1_0==x);
                newLabel = newLabel+1;
                F1_t(subs)=newLabel;
                Temp=Stats1(x,:);
                Stats1t(x,:)= toReplace;
                Stats1t(newLabel,:)=Temp;
                Stats1t{newLabel,'Label'}=newLabel;
                Stats1t = standardizeMissing(Stats1t,0,'DataVariables','Centroid');
                disp(['newLabel because min = ',num2str(min(eucledian)), 'in f',num2str(f),', nuc',num2str(x)]);
            end
        end
    end
    %if Divisions
        SubStats{N,1} = Stats0;
        SubStats{N+1,1} = Stats1t;
    %else
        %SubStats{N+1,1} = regionprops('table',F1_t,'Area','Centroid','Image','SubarrayIdx');
    %end    
    F1_t_RGB = label2rgb(max(F1_t(:,:,:),[],3), cmap, 'k', 'noshuffle');
end