
function [peakX]=findPeak(Y,X)

peakY=0;
peakX=0;
maxValue=0;
for i=1:length(X)
    
    if Y(i)> maxValue
        maxValue=Y(i);
        peakY=Y(i);
        peakX=X(i);
    end
    
end