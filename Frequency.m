clear all
close all
CurrentF=1;
mov=VideoReader('5Hz_324mV 00_00_00-00_00_15.avi');
while hasFrame(mov)    
    imCurrentFrame=readFrame(mov);
    mean_gray(CurrentF)=mean(mean(mean(imCurrentFrame)));   
    CurrentF=CurrentF+1;
end
mean_gray=mean_gray';