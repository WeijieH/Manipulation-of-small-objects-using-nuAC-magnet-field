function CorrelationAnalysis(fname, fps)
mov=VideoReader(fname);
TotalFrame=mov.Duration*mov.Framerate;
mov.Currenttime=0;    
imPrivousFrame=rgb2gray(readFrame(mov));
i=1;
mean_gray=zeros(TotalFrame,1);
mean_gray(1)=mean(mean(mean(imPrivousFrame)));   
Corr=zeros(TotalFrame-1,1);
while hasFrame(mov)    
    imCurrentFrame=rgb2gray(readFrame(mov));
    Corr(i,1)=corr2(imPrivousFrame,imCurrentFrame);
    imPrivousFrame=imCurrentFrame;
    i=i+1;
    mean_gray(i)=mean(mean(mean(imPrivousFrame))); 
end
Y=fft(Corr);
cfft_amp = abs(Y(:,1)/TotalFrame);

corr_fft = cfft_amp(1:TotalFrame/2+1);
corr_fft(1)=0;
corr_fft(2:end-1) = 2*corr_fft(2:end-1);

f = fps*(0:(TotalFrame/2))/TotalFrame;
figure
plot(f,corr_fft)
title('Correlation function')
xlabel('f (Hz)')
ylabel('ABS FFT')

figure
xlabel('f (Hz)')
yyaxis left
plot(Corr(:,1))
ylabel('Correlation')
yyaxis right
plot(mean_gray)
ylabel('BKG Intensity')
end