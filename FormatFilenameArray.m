function [ FormatedFN ] = FormatFilenameArray( fn )
f=char(fn{1});
[ ~, hz ] = FilenameProcess( f );
FormatedFN{1,1}=hz;
FormatedFN{1,2}=f;
cindex(1)=3;
for i=2:length(fn)
    f=char(fn{i});
    [ ~, hz ] = FilenameProcess( f );
    rindex=find([FormatedFN{:}]==hz);
    if isempty(rindex)
        FormatedFN{end+1,1}=hz;
        FormatedFN{end,2}=f;
        cindex(end+1)=3;
    else
        FormatedFN{rindex,cindex(rindex)}=f;
        cindex(rindex)=cindex(rindex)+1;
    end    
end
FormatedFN=sortrows(FormatedFN,1);
end

