

function [range]=FreqRange(referenceFreq,power,freq,percentPower)

totalArea=trapz(power);

[startFrame,endFrame]=deal(0);

for i=1:length(freq)
    if freq(i)==referenceFreq
        startFrame=i;
        endFrame=i;
    end
end

currentPower=0;
maxPower=totalArea*percentPower/100;

while currentPower<maxPower
    
    startFrame=startFrame-1;
    endFrame=endFrame+1;
    if startFrame<1
        startFrame=1;
    end
    if endFrame>length(freq)
        endFrame=length(freq);
    end
    currentPower=trapz(power(startFrame:endFrame));
    
end

startFreq=freq(startFrame);
endFreq=freq(endFrame);
range=[startFreq,endFreq];


