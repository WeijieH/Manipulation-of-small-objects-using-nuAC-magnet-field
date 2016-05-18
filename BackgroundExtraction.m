clear 
close all
mov=VideoReader('5Hz_324mV_processed_20jump_cuted.avi');
Background=rgb2gray(readFrame(mov)); %Foreground value
while hasFrame(mov)    
    FrameBuffer=rgb2gray(readFrame(mov));  
    l=FrameBuffer-Background;
    t=l>0;
    Background=Background+uint8(double(l).*t);
end
Background=imhistmatch(Background,FrameBuffer);
imshow(Background);