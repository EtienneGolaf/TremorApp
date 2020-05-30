%% Display movement : this script display the distance travelled traces for all PCs
% the Data structure PCsig_trial as obtained from running TremorMain is
% required


% close all
Frequency=Fs; %Hz

figure
%% Display whole period acceleration

legendVector={};
[maxA,maxV,maxD]=deal(0);
hold on
for pc=1:size(PCsig_period,2)

    acceleration=transpose(PCsig_period(:,pc));
    acceleration=acceleration/1000*9.8; % adjust to proper units (m/s^2)
    time=transpose(1:length(acceleration))*1/Frequency; % adjust to units, (s)
    
    % cumtrapz method (fast but innacurate at very very small displacements)
    velocity=detrend(cumtrapz(time,acceleration))*1000;
    velocity=filter(BandPassFilt,velocity);
    [gd,w]=grpdelay(BandPassFilt,length(velocity),Fs);
    delay=mean(gd);
    velocity(1:delay)=[];
    time=time(1:end-delay);
    acceleration=acceleration(1:end-delay);
    
    displacement=detrend(cumtrapz(time,velocity));
    displacement=filter(BandPassFilt,displacement);
    [gd,w]=grpdelay(BandPassFilt,length(displacement),Fs);
    delay=mean(gd);
    displacement(1:delay)=[];
    time=time(1:end-delay);
    acceleration=acceleration(1:end-delay);
    velocity=velocity(1:end-delay);
    
    
    legendVector{pc}=['PC',num2str(pc),' var ',num2str(AllPCdataS(pc).Var)];
    if max(abs(acceleration))>maxA
        maxA=max(acceleration);
    end
    if max(abs(velocity))>maxV
        maxV=max(velocity);
    end
    if max(abs(displacement))>maxD
        maxD=max(displacement);
    end
    
    subplot(3,1,1)
    hold on
    plot(time,acceleration)
    subplot(3,1,2)
    hold on
    plot(time,velocity*1000)
    subplot(3,1,3)
    hold on
    plot(time,displacement*1000)
    
end
subplot(3,1,1)
hold on
for i=1:size(TrialS,2)
    x1=TrialS(i).CutStart/Frequency;
    x2=TrialS(i).CutEnd/Frequency;
    if mod(i,2)==0
        p=patch([x1 x1 x2 x2],[-maxA maxA maxA -maxA],'b');
        alpha(p,.1);
    else
    p=patch([x1 x1 x2 x2],[-maxA maxA maxA -maxA],'r');
    alpha(p,.1);
    end
end
title('Acceleration traces for Protocol Period');
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
legend(legendVector)

subplot(3,1,2)
hold on
maxV=maxV*1000;
for i=1:size(TrialS,2)
    x1=TrialS(i).CutStart/Frequency;
    x2=TrialS(i).CutEnd/Frequency;
    if mod(i,2)==0
        p=patch([x1 x1 x2 x2],[-maxV maxV maxV -maxV],'b');
        alpha(p,.1);
    else
    p=patch([x1 x1 x2 x2],[-maxV maxV maxV -maxV],'r');
    alpha(p,.1);
    end
end
title('Velocity traces for Protocol Period');
xlabel('Time (s)')
ylabel('Velocity (mm/s)')

subplot(3,1,3)
hold on
maxD=maxD*1000;
for i=1:size(TrialS,2)
    x1=TrialS(i).CutStart/Frequency;
    x2=TrialS(i).CutEnd/Frequency;
    if mod(i,2)==0
        p=patch([x1 x1 x2 x2],[-maxD maxD maxD -maxD],'b');
        alpha(p,.1);
    else
    p=patch([x1 x1 x2 x2],[-maxD maxD maxD -maxD],'r');
    alpha(p,.1);
    end
end
title('Displacement traces for Protocol Period');
xlabel('Time (s)')
ylabel('Displacement (mm)')
suptitle(strrep(filename,'_',' '));
hold off
clear maxV maxA maxD