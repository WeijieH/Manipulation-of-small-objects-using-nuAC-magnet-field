%%Set up parameters
clc
clear
fn='02mgml_5Hz_R200fps_Result.mat';
ClusterRowNum=10;
Resolution=1.1;
live_th=300;
vlow=1;
vhigh=inf;
alow=50;
ahigh=5000;
%% Load and clean data
[ fps, hz ] = FilenameProcess( fn );
load(fn)
[Ref,CleanedResult] = CleanResult( Result,live_th );
NewData = ToSIUnits(ResultAnalysis( CleanedResult,Ref ), fps, Resolution);
SelectedData=SelectData( NewData,vlow,vhigh,alow,ahigh );
%% Calculate distance and displacement
[ wh,xy,totalframe ] = trajectory( Ref,CleanedResult, ClusterRowNum, Resolution);
dx=xy(2:end,1)-xy(1:end-1,1);
dy=xy(2:end,2)-xy(1:end-1,2);
totalframe=totalframe-1;
distance(1)=sqrt(dx(1)*dx(1)+dy(1)*dy(1));
displacement(1)=0;
for j=2:totalframe
    distance(j)=distance(j-1)+sqrt(dx(j)*dx(j)+dy(j)*dy(j));
    displacement(j)=sqrt((xy(j,1)-xy(1,1))^2+(xy(j,2)-xy(1,2))^2);
end
clear Result Ref CleanedResult dx dy j live_th
%% Poly1 fitting
time=1:totalframe;
time=time/fps;
time=time';
distance=distance';
displacement=displacement';
sf = fit(time,distance,'poly1');
sf_coeff = coeffvalues(sf);
sf_confint = confint(sf);
speed=sf_coeff(1);
speed_init=sf_coeff(2);
speed_err=(sf_confint(2,1) - sf_confint(1,1))/2;
speed_residual=distance-(speed*time+speed_init);

vf = fit(time,displacement,'poly1');
vf_coeff = coeffvalues(vf);
vf_confint = confint(vf);
velocity=vf_coeff(1);
velocity_init=vf_coeff(2);
velocity_err=(vf_confint(2,1) - vf_confint(1,1))/2;
velocity_residual=displacement-(velocity*time+velocity_init);
clear sf vf sf_coeff sf_confint vf_coeff vf_confint
%% FFT
f = fps*(0:(totalframe/2))/totalframe;
f=f';

srf=fft(speed_residual);
srf_amp = abs(srf/totalframe);
speed_residual_fft = srf_amp(1:totalframe/2+1);
speed_residual_fft(1)=0;
speed_residual_fft(2:end-1) = 2*speed_residual_fft(2:end-1);

vrf=fft(velocity_residual);
vrf_amp = abs(vrf/totalframe);
velocity_residual_fft = vrf_amp(1:totalframe/2+1);
velocity_residual_fft(1)=0;
velocity_residual_fft(2:end-1) = 2*speed_residual_fft(2:end-1);

whf=fft(wh);
wf_amp = abs(whf(:,1)/totalframe);
hf_amp = abs(whf(:,2)/totalframe);
width_fft = wf_amp(1:totalframe/2+1);
width_fft(1)=0;
width_fft(2:end-1) = 2*width_fft(2:end-1);
height_fft = hf_amp(1:totalframe/2+1);
height_fft(1)=0;
height_fft(2:end-1) = 2*height_fft(2:end-1);
clear srf srf_amp vrf vrf_amp whf wf_amp hf_amp totalframe
%% Delete the last element to match time vector
xy(end,:)=[];
wh(end,:)=[];

%% Peak finder
err=hz/20;
MPdistance=hz/2;
[pks,locs]=findpeaks(width_fft,f,'MinPeakDistance',MPdistance,'NPeaks',2,'SortStr','descend');
pks(locs<3)=0;
peakheight=max(pks);
peakheight_th=0.05*peakheight;
[pks,locs]=findpeaks(width_fft,f,'MinPeakDistance',MPdistance, 'MinPeakHeight',peakheight_th);
for i = 1:6         
    if isempty(pks(i*hz-err<locs&locs<i*hz+err))
        widthFFT_peak(i,1)=i*hz;
        widthFFT_peak(i,2)=0;
    else 
        widthFFT_peak(i,1)=locs(i*hz-err<locs&locs<i*hz+err);
        widthFFT_peak(i,2)=pks(i*hz-err<locs&locs<i*hz+err);
    end
end
plot(f,width_fft)
set(gca,'FontSize',18)
axis([0 fps/2 0 1.1*peakheight])
xlabel('Frequency (Hz)')
ylabel('Amp of FFT')
hold on
nonzero_index=widthFFT_peak(:,2)>0;
plot(widthFFT_peak(nonzero_index,1),widthFFT_peak(nonzero_index,2),'x','MarkerSize',12, 'LineWidth', 2)
hold off
clear err i nonzero_index peakheight_th MPdistance