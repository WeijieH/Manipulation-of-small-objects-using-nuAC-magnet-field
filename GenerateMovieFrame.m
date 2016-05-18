clear 
close all
fname='old\02mgml_5Hz_100fps_NF_4.avi';
mov=VideoReader(fname);
%roi = [left top x, y, width, height]
roi=[321 48 26 26];
startframe=186;
endframe=196;
i=startframe;
mov.Currenttime=startframe/mov.FrameRate;
fn=strsplit(char(fname),'.');
while hasFrame(mov)    
    if (i>endframe)
        break
    end
    i=i+1;
    imgname=strcat(char(fn(1)),'_frame',num2str(i),'.png');
    FrameBuffer=rgb2gray(readFrame(mov));  
    imwrite(FrameBuffer(roi(2):roi(2)+roi(4),roi(1):roi(1)+roi(3)),imgname);
end