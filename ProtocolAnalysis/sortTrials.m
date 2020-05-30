function [EpochS,pkTime]=sortTrials(signal,pkTime,protocol,protocoltype,CutWindow,Frequency)

switch protocoltype
    case 1
        if mod(length(pkTime),2)~=0
            pkTime=pkTime(1:end-1);
        end
    case 2
        % we average timestamp of start signal (two light peaks)
        trialCount=1;
        newTime=[];
       for i=1:3:length(pkTime)
           try
           newTime(trialCount)=mean(pkTime(i:i+1));
           newTime(trialCount+1)=pkTime(i+2);
           trialCount=trialCount+2;
           catch
           end
       end
       
       pkTime=newTime;
     
end

trialCount=1;
protocolCount=1;
for i=1:2:length(pkTime)-1
    if mod(trialCount,2)~=0
        
        EpochS(trialCount).Trial=('Rest');
        EpochS(trialCount).SelectStart=pkTime(i);
        EpochS(trialCount).SelectEnd=pkTime(i+1);
        
        [cutSignal,CutTimes] = CutFromCenter(signal,pkTime(i),pkTime(i+1),CutWindow,Frequency);
        
        EpochS(trialCount).CutStart=CutTimes(1);
        EpochS(trialCount).CutEnd=CutTimes(2);
        EpochS(trialCount).SelectSignals=transpose(signal(pkTime(i):pkTime(i+1),:));
        EpochS(trialCount).CutSignals=cutSignal;
        
        trialCount=trialCount+1;
        
    else
        EpochS(trialCount).Trial=(protocol(protocolCount));
        protocolCount=protocolCount+1;
        if protocolCount>length(protocol)
            protocolCount=1;
        end
        EpochS(trialCount).SelectStart=pkTime(i);
        EpochS(trialCount).SelectEnd=pkTime(i+1);
        
        [cutSignal,CutTimes] = CutFromCenter(signal,pkTime(i),pkTime(i+1),CutWindow,Frequency);
        
        EpochS(trialCount).CutStart=CutTimes(1);
        EpochS(trialCount).CutEnd=CutTimes(2);
        EpochS(trialCount).SelectSignals=transpose(signal(pkTime(i):pkTime(i+1),:));
        EpochS(trialCount).CutSignals=cutSignal;
        
        trialCount=trialCount+1;
        
    
    end
end