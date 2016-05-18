function [ FFT_width_ratios ] = FFTData( CleanedResult,NewData , fps, hz )
l=size(CleanedResult,1);

FFT_width_ratios(:,1)=NewData(:,1);
FFT_width_ratios(:,2)=NewData(:,6);
FFT_width_ratios(:,3)=NewData(:,7);
FFT_width_ratios(:,4)=sqrt(NewData(:,10).^2+NewData(:,11).^2);

for i=1:l    
    start=find(CleanedResult(i,:,4),1);
    totalframe=nnz(CleanedResult(i,:,4));
    width=CleanedResult(i,start:start+totalframe-1,4);
    wf=fft(width);
    wf_amp = abs(wf/totalframe);
    
    halfponit = floor(totalframe/2+1);
    width_fft = wf_amp(1:halfponit);
    width_fft(1)=0;
    width_fft(2:end-1) = 2*width_fft(2:end-1);
   
    f = fps*(0:(totalframe/2))/totalframe;
    f=f';
    
    err=hz/20;
    MPdistance=hz/2;
    [pks,locs]=findpeaks(width_fft,f,'MinPeakDistance',MPdistance,'NPeaks',2,'SortStr','descend');
    pks(locs<3)=0;
    peakheight=max(pks);
    peakheight_th=0.05*peakheight;
    [pks,locs]=findpeaks(width_fft,f,'MinPeakDistance',MPdistance, 'MinPeakHeight',peakheight_th);
    for j = 1:6         
        if isempty(pks(j*hz-err<locs&locs<j*hz+err))
            widthFFT_peak(j,1)=j*hz;
            widthFFT_peak(j,2)=0;
        else 
            widthFFT_peak(j,1)=locs(j*hz-err<locs&locs<j*hz+err);
            widthFFT_peak(j,2)=pks(j*hz-err<locs&locs<j*hz+err);
        end
    end
    
    %2w/(w+2w)
    FFT_width_ratios(i,5)=widthFFT_peak(2,2)/(widthFFT_peak(2,2)+widthFFT_peak(1,2));
    
    %2w/sum(1~6w)
    FFT_width_ratios(i,6)=widthFFT_peak(2,2)/sum(widthFFT_peak(:,2));
    
    %2+4+6w/sum(1~6w)
    FFT_width_ratios(i,7)=(widthFFT_peak(2,2)+widthFFT_peak(4,2)+widthFFT_peak(6,2))/sum(widthFFT_peak(:,2));
end
end

