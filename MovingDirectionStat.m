function [ MovingDirection ] = MovingDirectionStat( ResultName, life_th, velocity_th, sizelow, sizehigh)
index =1;
Resolution = 1.1;
for r=ResultName
    PosVelocity=0;
    NegVelocity=0;
    NotMoving=0;
    %Process filename to extract fps and hz infomation
    fn=char(r);
    [ fps, hz ] = FilenameProcess( fn );
    %load and process result data
    load(fn);
    [Ref,CleanedResult] = CleanResult( Result,life_th );
    data = ResultAnalysis( CleanedResult,Ref );
    NewData=ToSIUnits(data, fps,Resolution);
    for i = 1:size(data,1)
        if (NewData(i,6)>=sizelow&&NewData(i,6)<sizehigh)            
            if (NewData(i,12)>velocity_th)
                if (NewData(i,10)>0)
                    PosVelocity=PosVelocity+1;
                else
                    NegVelocity=NegVelocity+1;
                end
            else
                NotMoving=NotMoving+1;
            end           
        end
    end
    MovingDirection(index,1)=hz;
    MovingDirection(index,2)=PosVelocity;
    MovingDirection(index,3)=NegVelocity;
    MovingDirection(index,4)=NotMoving;   
    index = index + 1;   
end
end