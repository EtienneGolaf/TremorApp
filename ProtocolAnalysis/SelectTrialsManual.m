%% SelectTrialsManual
% This function is used to select an acc signal window manually


function [StartStamp,EndStamp,all] = SelectTrialsManual(PCsignals,light,explained,Freq)

figure;
subplot(2,1,1);
X=transpose((1:size(PCsignals,1)));
plot(X,PCsignals(:,1),X,PCsignals(:,2),X,PCsignals(:,3));
title('Select Start and End for each Trial, press Return when done');
legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
xlabel('Sample #');

subplot(2,1,2); 
plot(light,'r');
legend('Luminosity');
xlabel('Sample #');

[t_times,sig_values] = ginput;
t_times=t_times;

if mod(length(t_times),2)~=0
    error('Uneven start and end times in SelectTrialsManual');
end

[sIndex,eIndex]=deal(1);
eIndex=1;

[StartStamp,EndStamp]=deal(zeros(length(t_times)/2,1));

for i=1:length(t_times)
    if mod(i,2)==0
        StartStamp(sIndex)=t_times(i);
        sIndex=sIndex+1;
    else
        EndStamp(eIndex)=t_times(i);
        eIndex=eIndex+1;
    end
end
