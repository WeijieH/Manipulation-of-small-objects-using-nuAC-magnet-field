function [ selected_data ] = SelectData( Newdata,vlow,vhigh,alow,ahigh )
l=size(Newdata,1);
selected_data=zeros(1,size(Newdata,2));
ind=1;
for i=1:l
    if(Newdata(i,6)>=alow&&Newdata(i,6)<ahigh)
        v=sqrt(Newdata(i,10)^2+Newdata(i,11)^2);
        if(v>=vlow&&v<vhigh)
            selected_data(ind,:)=Newdata(i,:);
            ind=ind+1;
        end
    end
end
end

