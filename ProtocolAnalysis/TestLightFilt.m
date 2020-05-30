


datalocation = 'C:\Users\User\Desktop\Tremor Analysis\TestData\';
filename = 'JL_left wrist_026357_2016-04-29 11-10-12.csv';

%% Parameters

Fs=100; % in Hz

% Protocol info
ProtocolOrder={'Posture'};
% ProtocolOrder={'Hand','2Hands','Elbows'};
%ProtocolOrder={'Hand','2Hands','Elbows'}; % update this and implement autofill
ProtocolType=1;  % 1=signle peak trial start, 2=double peak trial start
ConditionNames={'Posture','Rest'};
NumTrials = 3;
NumConditions = 2;

% Spectral analysis
PCAorder='Segment'; % 'Raw'=PCA on raw data, 'Segment'=PCA on protocol segment only
TimeWindow=10; % length of segment data to be taken from trial (seconds)
PercentPower=50; % % power to include in freq range finding

% Frequency filter range
BandFreqRange=[1,20]; % in Hz

%% Import Data

[time, x, y, z, light] = OpenAccFile([datalocation filename]);

Win=100;
buffer=round(Win/2);
lightfilt=light;
for i=1+buffer:length(light)-buffer
lightfilt(i)=mean(light(i-buffer:i+buffer));
end

printRange=[150000,220000];

figure
hold on
% plot(light(printRange(1):printRange(2)));
plot(lightfilt(printRange(1):printRange(2)));
hold off


