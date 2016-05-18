function [ AveSpeed ] = AveragedSpeed( ResultName, life_th, sizelow, sizehigh )
index =1;
Resolution=1.1;
formated_fn=FormatFilenameArray( ResultName );
for r=1:size(formated_fn,1)
    j = 1;
    speed(1)=0;
    velocity_fitting(1)=0;
    velocity_se(1)=0;
    for c=2:size(formated_fn,2)
        if isempty(formated_fn{r,c})
            continue
        end
        fn=char(formated_fn{r,c});
        [ fps, hz ] = FilenameProcess( fn );
        load(fn);
        [Ref,CleanedResult] = CleanResult( Result,life_th );
        data = ResultAnalysis( CleanedResult,Ref );
        NewData=ToSIUnits(data, fps, Resolution);        
        for i = 1:size(NewData,1)
            if (NewData(i,6)>=sizelow&&NewData(i,6)<sizehigh)
                speed(j)=NewData(i,4);
                velocity_fitting(j)=NewData(i,12);
                velocity_se(j)=sqrt(NewData(i,10)^2+NewData(i,11)^2);
                j=j+1;
            end
        end
    end    
    AveSpeed(index,1)=hz;
    AveSpeed(index,2)=mean(speed);
    AveSpeed(index,3)=std(speed);
    AveSpeed(index,4)=mean(velocity_fitting);
    AveSpeed(index,5)=std(velocity_fitting);
    AveSpeed(index,6)=mean(velocity_se);
    AveSpeed(index,7)=std(velocity_se);
    AveSpeed(index,8)=j-1;
    index = index + 1;
    clear speed velocity_fitting velocity_se
end
end