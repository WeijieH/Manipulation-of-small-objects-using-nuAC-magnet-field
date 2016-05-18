function [Ref,CleanedResult] = CleanResult( Result,life_th, drawHist )
CleanedResult=zeros(1,size(Result,2),size(Result,3));
idx=1;
nzeros=zeros(size(Result,1),1);
if (nargin < 3)
    drawHist=false;
end
for i=1:size(Result,1)
    nzeros(i)=nnz(Result(i,:,4));
    if (nzeros(i)>life_th) 
        CleanedResult(idx,:,:)=Result(i,:,:);
        Ref(idx)=i;
        idx=idx+1;
    end
end
if drawHist
    histogram(nzeros,'BinWidth',25)
    title('Cluster tracker life')
end
end

