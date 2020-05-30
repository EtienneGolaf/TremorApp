% Populate epochs is a function that applies protocol steps to a given data
% set to identify trials using light signals. The protocol list assumes
% each posture is follow by a rest.

function [EpochS] = PopEpochs(signal,light,protocol,protocoltype,explained,CutWindow,Frequency,Method)

EpochS=struct('Trial',[],'SelectStart',[],'SelectEnd',[],'SelectSignals',[],'CutStart',[],'CutEnd',[],'CutSignals',[]);

switch Method
    case 'Auto'
        %% Try automatically
        [pkValue,pkTime]=findpeaks(light,'MinPeakHeight',3000,'MinPeakDistance',100);
        
        [EpochS,pkTime]=sortTrials(signal,pkTime,protocol,protocoltype,CutWindow,Frequency);
        
        %% Ask user confirmation
        answer='No';
        while ~strcmp(answer,'Yes')
            
            % Graph selected trials
            
            X=transpose((1:size(signal,1)));
            
            figure
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
            subplot(2,1,1);
            plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
            hold on;
            for epochcount = 1:round(length(pkTime)/2)
                
                if mod(epochcount,2) == 0
                    c = [1 0 0];
                else
                    c = [0 0 1];
                end
                text(pkTime(epochcount*2-1),(1.5),EpochS(epochcount).Trial);
                try
                    p = patch([pkTime(epochcount*2-1),pkTime(epochcount*2),pkTime(epochcount*2),pkTime(epochcount*2-1)],...
                        [-1,-1,1,1],c);
                    alpha(p,.1);
                catch
                    fprintf('Rest epoch missing??');
                end
            end
            legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
            
            title('Selected Epochs')
            
            subplot(2,1,2);
            plot(light,'r');
            for i=1:length(pkTime)
                line([pkTime(i),pkTime(i)],[0 30000]);
            end
            legend('Luminosity');
            xlabel('X (#samples)');
            
            % prompt user to confirm selection
            
            answer = questdlg('Confirm epoch population?', ...
                'Epoch Selection', ...
                'Yes','No, Manual Selection','Yes');
            
            switch answer
                case 'Yes'
                    fprintf('\nTrial Selection Finished');
                case 'No, Manual Selection'
                    close(gcf)
                    % Manual Backup
                    
                    clear pkTime pkValue EpochS
                    figure
                    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
                    subplot(2,1,1);
                    X=transpose((1:size(signal,1)));
                    plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
                    title('Select Start and End for each Trial, press Enter when done');
                    legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
                    xlabel('X (#samples)');
                    
                    subplot(2,1,2);
                    plot(light,'r');
                    legend('Luminosity');
                    xlabel('X (#samples)');
                    
                    [pkTime,pkValue] = ginput;
                    close(gcf)
                    
                    if mod(length(pkTime),2)~=0
                        error('Uneven start and end times in SelectTrialsManual');
                    end
                    
                    EpochS=sortTrials(signal,pkTime,protocol,protocoltype,CutWindow,Frequency);
                    
            end
        end
        close(gcf)
        % Display final graph with cut epochs
        figure
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        subplot(2,1,1);
        plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
        hold on;
        for epochcount = 1:size(EpochS,2)
            
            if mod(epochcount,2) == 0
                c = [1 0 0];
            else
                c = [0 0 1];
            end
            
            text(EpochS(epochcount).CutStart,(1.5),EpochS(epochcount).Trial);
            
            p = patch([EpochS(epochcount).CutStart,EpochS(epochcount).CutEnd,EpochS(epochcount).CutEnd,EpochS(epochcount).CutStart],...
                [-1,-1,1,1],c);
            alpha(p,.1);
            
        end
        legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
        
        title('Final Processed Epochs')
        
        subplot(2,1,2);
        plot(light,'r');
        for i=1:length(pkTime)
            line([pkTime(i),pkTime(i)],[0 30000]);
        end
        legend('Luminosity');
        xlabel('X (#samples)');
    case 'Manual'
        figure
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        subplot(2,1,1);
        X=transpose((1:size(signal,1)));
        plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
        title('Select Start and End for each Trial, press Enter when done');
        legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
        xlabel('Sample #');
        
        subplot(2,1,2);
        plot(light,'r');
        legend('Luminosity');
        xlabel('Sample #');
        
        [pkTime,pkValue] = ginput;
        close(gcf)
        
        if mod(length(pkTime),2)~=0
            error('Uneven start and end times in SelectTrialsManual');
        end
        
        EpochS=sortTrials(signal,pkTime,protocol,protocoltype,CutWindow,Frequency);
        
        %% Ask user confirmation
        answer='No';
        while ~strcmp(answer,'Yes')
            
            % Graph selected trials
            
            X=transpose((1:size(signal,1)));
            
            figure
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
            subplot(2,1,1);
            plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
            hold on;
            for epochcount = 1:round(length(pkTime)/2)
                
                if mod(epochcount,2) == 0
                    c = [1 0 0];
                else
                    c = [0 0 1];
                end
                text(pkTime(epochcount*2-1),(1.5),EpochS(epochcount).Trial);
                try
                    p = patch([pkTime(epochcount*2-1),pkTime(epochcount*2),pkTime(epochcount*2),pkTime(epochcount*2-1)],...
                        [-1,-1,1,1],c);
                    alpha(p,.1);
                catch
                    fprintf('Rest epoch missing??');
                end
            end
            legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
            
            title('Selected Epochs')
            
            subplot(2,1,2);
            plot(light,'r');
            for i=1:length(pkTime)
                line([pkTime(i),pkTime(i)],[0 30000]);
            end
            legend('Luminosity');
            xlabel('X (#samples)');
            
            % prompt user to confirm selection
            
            answer = questdlg('Confirm epoch population?', ...
                'Epoch Selection', ...
                'Yes','No, Manual Selection','Yes');
            
            switch answer
                case 'Yes'
                    fprintf('\nTrial Selection Finished');
                case 'No, Manual Selection'
                    close(gcf)
                    % Manual Backup
                    
                    clear pkTime pkValue EpochS
                    figure
                    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
                    subplot(2,1,1);
                    X=transpose((1:size(signal,1)));
                    plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
                    title('Select Start and End for each Trial, press Enter when done');
                    legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
                    xlabel('X (#samples)');
                    
                    subplot(2,1,2);
                    plot(light,'r');
                    legend('Luminosity');
                    xlabel('X (#samples)');
                    
                    [pkTime,pkValue] = ginput;
                    close(gcf)
                    
                    if mod(length(pkTime),2)~=0
                        error('Uneven start and end times in SelectTrialsManual');
                    end
                    
                    EpochS=sortTrials(signal,pkTime,protocol,protocoltype,CutWindow,Frequency);
                    
            end
        end
        close(gcf)
        % Display final graph with cut epochs
        figure
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        subplot(2,1,1);
        plot(X,signal(:,1),X,signal(:,2),X,signal(:,3));
        hold on;
        for epochcount = 1:size(EpochS,2)
            
            if mod(epochcount,2) == 0
                c = [1 0 0];
            else
                c = [0 0 1];
            end
            text(pkTime(epochcount*2-1),(1.5),EpochS(epochcount).Trial);
            
            p = patch([EpochS(epochcount).CutStart,EpochS(epochcount).CutEnd,EpochS(epochcount).CutEnd,EpochS(epochcount).CutStart],...
                [-1,-1,1,1],c);
            alpha(p,.1);
            
        end
        legend(['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])
        
        title('Final Processed Epochs')
        
        subplot(2,1,2);
        plot(light,'r');
        for i=1:length(pkTime)
            line([pkTime(i),pkTime(i)],[0 30000]);
        end
        legend('Luminosity');
        xlabel('X (#samples)');
        
        
end



