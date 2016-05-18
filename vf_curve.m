clear

live_th=300;
Resolution=1.1;
alow=100;
ahigh=inf;
vlow=1;
vhigh=inf;
load('fn_1mg.mat')
len=length(fn_1mg);
velocity=zeros(1,len);

for i=1:len
    fn=char(fn_1mg{i});
    [ fps, hz ] = FilenameProcess( fn );
    load(fn)
    [Ref,CleanedResult] = CleanResult( Result,live_th );
    NewData = ToSIUnits(ResultAnalysis( CleanedResult,Ref ), fps, Resolution);
    SelectedData=SelectData( NewData,vlow,vhigh,alow,ahigh );
    v=sqrt(SelectedData(:,10).^2+SelectedData(:,11).^2);
    velocity(1,i)=hz;
    velocity(2:length(v)+1,i)=v;    
    clear Ref Result CleanedResult NewData SelectedData
end
clear fps hz v alow ahigh vlow vhigh live_th Resolution

cleanedv=unique(velocity(1,:));

for i=1:len
    px=find(cleanedv(1,:)==velocity(1,i));
    py=nnz(cleanedv(:,px))+1;
    plen=nnz(velocity(:,i))-2+py;
    t=velocity(:,i)>0;
    t(1)=false;
    cleanedv(py:plen,px)=velocity(t,i);    
end
cleanedv(cleanedv==0)=nan;
clear velocity px py t plen

vf=cleanedv(1,:)';
n=size(cleanedv,1);
for i=1:size(cleanedv,2)
    vf(i,2)=mean(cleanedv(2:end,i),'omitnan');
    vf(i,3)=std(cleanedv(2:end,i),'omitnan');
    vf(i,4)=n-sum(isnan(cleanedv(:,i)))-1;
end
clear i len fn n