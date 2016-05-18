function [correlation, ave_corr ] = SingleClusterCorr( VideoFileName, ClusterID, CriticalFrame, BoxSize )
if (nargin < 4)
    BoxSize=32;
end
[ fps, hz ] = FilenameProcess( VideoFileName );
fn=strsplit(VideoFileName,'.');
DataName=strcat('TrackingData/',char(fn(1)),'_Result.mat');
OutputName=strcat(char(fn(1)),'_Cluster',num2str(ClusterID),'.avi');
FrameJump=round(fps/(2*hz));


load(DataName)
start=find(Result(ClusterID,:,4),1);
life=nnz(Result(ClusterID,:,4));
StartFrame=ceil(start/FrameJump)*FrameJump+mod(CriticalFrame,FrameJump)+round(fps/(4*hz));
EndFrame=start+life-1;

xy(:,:)=Result(ClusterID,StartFrame:EndFrame,1:2);
wh(:,:)=Result(ClusterID,StartFrame:EndFrame,4:5);

mov=VideoReader(VideoFileName);
Framerate=mov.FrameRate;
v_out=VideoWriter(OutputName,'Motion JPEG AVI');
v_out.FrameRate=2;
open(v_out);

mov.Currenttime=StartFrame/mov.FrameRate;
PreFrameBuffer=rgb2gray(readFrame(mov));
maxY=size(PreFrameBuffer,2);
maxX=size(PreFrameBuffer,1);
ind=1;
f=1;
cpb = ConsoleProgressBar();
cpb.setLeftMargin(4);   % progress bar left margin
cpb.setTopMargin(1);    % rows margin
cpb.setLength(40);      % progress bar length: [.....]
cpb.setMinimum(0);      % minimum value of progress range [min max]
cpb.setMaximum(100);    % maximum value of progress range [min max]
% Set text position
cpb.setPercentPosition('left');
cpb.setTextPosition('right');
cpb.start();
for i=(StartFrame/Framerate):(FrameJump/Framerate):(EndFrame/Framerate)
    mov.Currenttime=i;
    CurFrameBuffer=rgb2gray(readFrame(mov));    
    halfwidth=round(wh(f,1)/2);
    halfheight=round(wh(f,2)/2);
    left=max(xy(f,1)-halfwidth,1);
    right=min(xy(f,1)+halfwidth,maxY);
    up=max(xy(f,2)-halfheight,1);
    down=min(xy(f,2)+halfheight,maxX);
    imPriviousBox=imresize(PreFrameBuffer(up:down, left:right),[BoxSize BoxSize]);
    flippedim=flip(imPriviousBox,2);
    f=i*Framerate-StartFrame+1;
    halfwidth=round(wh(f,1)/2);
    halfheight=round(wh(f,2)/2);
    left=max(xy(f,1)-halfwidth,1);
    right=min(xy(f,1)+halfwidth,maxY);
    up=max(xy(f,2)-halfheight,1);
    down=min(xy(f,2)+halfheight,maxX);
    imCurrentBox=imresize(CurFrameBuffer(up:down, left:right) ,[BoxSize BoxSize]);
    correlation(ind)=corr2(flippedim,imCurrentBox);
    writeVideo(v_out,imCurrentBox); 
    PreFrameBuffer=CurFrameBuffer;
    ind=ind+1;
    k=100*i/(EndFrame/Framerate);
    cpb.setValue(k);
end
ave_corr=mean(correlation);
correlation=correlation';
close(v_out)
cpb.setValue(100);
cpb.stop();
end

