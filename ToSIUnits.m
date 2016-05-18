function [ NewData ] = ToSIUnits( data, fps, Resolution )
NewData=data;
NewData(:,4:5)=NewData(:,4:5)*Resolution*fps;
NewData(:,6:7)=NewData(:,6:7)*Resolution*Resolution;
NewData(:,10:13)=NewData(:,10:13)*Resolution*fps;
end

