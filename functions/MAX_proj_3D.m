function [max_proj]= MAX_proj_3D(A)
    max_proj = double(zeros(size(A,1), size(A,2),size(A,4)));
    for f = 1:size(A,4)
        max_proj(:,:,f) = max(A(:,:,:,f),[],3);
    end
end