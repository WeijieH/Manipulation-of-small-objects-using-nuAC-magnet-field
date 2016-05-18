figure

for i=1:5
    subplot(5,1,i);
    hist(cleanedv(2:end,i+5),20)
end