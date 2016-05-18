function data = ResultAnalysis( CleanedResult,Ref )
l=size(CleanedResult,1);
data=zeros(l,9);

%fill in cluster IDs
data(:,1)=Ref(1,:);

for i=1:l
%Calculate start and end Frame#
start=find(CleanedResult(i,:,4),1);
life=nnz(CleanedResult(i,:,4));
data(i,2)=start;
data(i,3)=start+life-1;

%Calculate speed and error
xy(:,1)=CleanedResult(i,data(i,2):data(i,3),1);
xy(:,2)=CleanedResult(i,data(i,2):data(i,3),2);
dx=xy(2:end,1)-xy(1:end-1,1);
dy=xy(2:end,2)-xy(1:end-1,2);
x(1)=1;
distance(1)=sqrt(dx(1)*dx(1)+dy(1)*dy(1));
displacement(1)=0;
for j=2:length(dx)
    x(j)=j;
    distance(j)=distance(j-1)+sqrt(dx(j)*dx(j)+dy(j)*dy(j));
    displacement(j)=sqrt((xy(j,1)-xy(1,1))^2+(xy(j,2)-xy(1,2))^2);
end
cf = fit(x',distance','poly1');
cf_coeff = coeffvalues(cf);
cf_confint = confint(cf);
data(i,4)=cf_coeff(1);
data(i,5)=(cf_confint(2,1) - cf_confint(1,1))/2;

%Calculate area and error
aa(:,1)=CleanedResult(i,data(i,2):data(i,3),4);
aa(:,2)=CleanedResult(i,data(i,2):data(i,3),5);
area=aa(:,1).*aa(:,2);
data(i,6)=mean(area);
data(i,7)=std(area);

%Calculate aspect ratio and error
asp=aa(:,1)./aa(:,2);
data(i,8)=mean(asp);
data(i,9)=std(asp);


%Calculate vector velocity (Vx,Vy)
data(i,10)=(xy(end,1)-xy(1,1))/(data(i,3)-data(i,2));
data(i,11)=(xy(end,2)-xy(1,2))/(data(i,3)-data(i,2));

%Caculate velocity and error
vf = fit(x',displacement','poly1');
vf_coeff = coeffvalues(vf);
vf_confint = confint(vf);
data(i,12)=vf_coeff(1);
data(i,13)=(vf_confint(2,1) - vf_confint(1,1))/2;


%Clean up
clear xy aa area asp dx dy x distance displacement
end

end

