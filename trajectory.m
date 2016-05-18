function [ wh,xy,totalframe ] = trajectory(Result, CulsterID, Resolution, drawTrajectory )
if (nargin < 4)
    drawTrajectory=false;
end
s=find(Result(CulsterID,:,4),1);
e=s+nnz(Result(CulsterID,:,4))-1;
xy(:,1)=Result(CulsterID,s:e,1);
xy(:,2)=Result(CulsterID,s:e,2);
wh(:,1)=Result(CulsterID,s:e,4);
wh(:,2)=Result(CulsterID,s:e,5);
dx=xy(2:end,1)-xy(1:end-1,1);
dy=xy(2:end,2)-xy(1:end-1,2);
x(1)=1;
y(1)=sqrt(dx(1)*dx(1)+dy(1)*dy(1));
for j=2:length(dx)
    x(j)=j;
    y(j)=y(j-1)+sqrt(dx(j)*dx(j)+dy(j)*dy(j));
end
totalframe=e-s+1;
xy=xy*Resolution;
wh=wh*Resolution;
if drawTrajectory
    hold on
    lengend_text=strcat('Cluster #',num2str(CulsterID));
    scatter(xy(:,1),xy(:,2),'filled','DisplayName',lengend_text)
    oh=plot(xy(1,1),xy(1,2),'o','MarkerSize',32, 'LineWidth', 2, 'color', 'black');
    hAnnotation = get(oh,'Annotation');
    hLegendEntry = get(hAnnotation','LegendInformation');
    set(hLegendEntry,'IconDisplayStyle','off')
    hold off
end
end