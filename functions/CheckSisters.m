function[F1_t,Stats0,Stats1t,newLabel] = CheckSisters(F1_0,F1_t,x,closest,closest_index,Stats0,Stats1,Stats1t,newLabel,f)
            subs = find(F1_0==x);
            sister = find(F1_t==closest);
            %toReplace = Stats1t(1,:); 
            %for r = 1:size(toReplace,2); try; toReplace(1,r) = table(NaN);end; end
            if isempty(sister)==1 %if there is no other cell already tracked with that number
                F1_t(subs)=closest;
                Temp=Stats1(x,:);
                %Stats1t(x,:)= toReplace;
                Stats1t(closest_index,:)=Temp;
                Stats1t{closest_index,'Parent'}=closest;
                Stats1t{closest_index,'Label'}=closest;
                Stats0{closest_index,'Daughters'}=[closest NaN];
            else %replace both cells with newLabels and tag as daughter cells
                disp(['Division! in cell ',num2str(min(closest)), ' in f',num2str(f)]);
                F1_t(subs)=newLabel+1;
                F1_t(sister)=newLabel+2;
                Stats1t(newLabel+1,:)=Stats1(x,:); %new daughter
                %Stats1t(x,:)=toReplace;
                Stats1t(newLabel+2,:)=Stats1t(closest,:); %sister
                %Stats1t(closest,:)=toReplace;
                Stats1t{newLabel+1,'Parent'}=closest;
                Stats1t{newLabel+2,'Parent'}=closest;
                Stats1t{newLabel+1,'Label'}=newLabel+1;
                Stats1t{newLabel+2,'Label'}=newLabel+2;
                Stats0{closest_index,'Daughters'}=[newLabel+1 newLabel+2];
                newLabel = newLabel+2;
            end 
            Stats0 = standardizeMissing(Stats0,0,'DataVariables','Centroid');
            Stats1t = standardizeMissing(Stats1t,0,'DataVariables','Centroid');
end