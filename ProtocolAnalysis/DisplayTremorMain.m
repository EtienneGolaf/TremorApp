%% Display Tremor Main

% this script is used after running TremorMain to plot the analysis
%% 'AllPCdataS' and 'f' as computed by Tremor Main must be in the workspace 

PC=1;
axisLim=[0 25 0 0.5];
lineWidth=2;
PlotAll=1;

%% Load data
Data=AllPCdataS(PC).DataS;
variance=AllPCdataS(PC).Var;
numConditions=size(Data,2);

%% Graph
% colors=distinguishable_colors(numConditions,'w');
colors=colormap(lines);
legendCount=1;
figure
hold on

%plot averages
for condition=1:numConditions
    X=f;
    Y=Data(condition).PowerAverage;
    plot(X,Y, 'Color',colors(condition,:),'LineWidth',2);
    legendNames{condition}=Data(condition).Condition;
    
    Xtext=round(Data(condition).PeakFreq,2);
    Ytext=max(Y);
    text(Xtext,Ytext,['\downarrow ',num2str(Xtext),' Hz'],'Color',colors(condition,:));
end
%plot signals
if PlotAll
    for condition=1:numConditions
        X=f;
        Y=Data(condition).Power;
        plot(X,Y,'Color',colors(condition,:),'LineStyle',':');
        legendCount=legendCount+1;
    end
end

axis(axisLim)
title(['PC',num2str(PC),' ',num2str(round(variance)),'%var. Single Sided Amplitude Spectrum']);
xlabel('Frequency (Hz)')
ylabel('Power')
legend(legendNames)


hold off

