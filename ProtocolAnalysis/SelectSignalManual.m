%% SelectTrialsManual
% This function is used to select an acc signal window manually


function [StartStamp,EndStamp] = SelectTrialsManual(signals,light,explained,PCAorder,Freq)

selection=0;
cutbotch=1;
while selection==0
    
    
    % cut signal (do no uncomment, this is for botched recordings
%     if cutbotch==1
%         longeur=round(size(signals,1)/4);
%         signals=signals(1:longeur,:);
%         light=light(1:longeur);
%         cutbotch=0;
%     end
    
    figure
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    subplot(2,1,1);
    X=transpose((1:size(signals,1)));
    plot(X,signals(:,1),X,signals(:,2),X,signals(:,3));
    title('Select Start and End of Desired Protocol Period');
    switch PCAorder
        case 'Raw'
            legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
            xlabel('Elapsed Time (min)');
        case 'Segment'
            legend('X','Y','Z');
            xlabel('Sample #');
    end
    
    subplot(2,1,2);
    
    plot(light,'r');
    xlabel('Sample #');
    legend('Luminosity');
    
    [DataInterval,SignalInterval] = ginput(2);
    
    % asking if selection is good
    
    close 
    figure
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    
    subplot(2,1,1);
    span=DataInterval;
    Xselect=X(span(1):span(2));
    plot(Xselect,signals(span(1):span(2),1),...
        Xselect,signals(span(1):span(2),2),...
        Xselect,signals(span(1):span(2),3));
    title('Select Start and End of Desired Protocol Period');
    
    subplot(2,1,2);
    plot(Xselect,light(span(1):span(2)),'r');
    xlabel('Sample #');
    legend('Luminosity');
    
    answer = questdlg('Keep this selection?','Segment Selection','Yes','No, select another','No, select another');
    if strcmp(answer,'Yes')
        selection=1;
    end
    
    close all
end

StartStamp=DataInterval(1);
EndStamp=DataInterval(2);
