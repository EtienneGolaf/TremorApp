%% CutFromCenter
% This function is used to cut a signal from the center of a trial at a
% given time length

% Window in seconds, Frequency in Hz


function [Signal,CutFrames] = CutFromCenter(RawSignal,Start,End,Window,Frequency)

RawSignal=transpose(RawSignal);

SignalBuffer=round((Window/2)*Frequency); % adjust for number of readings

Center = round((Start+End)/2);

try
Signal=RawSignal(:,Center-SignalBuffer:Center+SignalBuffer);
catch
    error('center cut error');
end
CutFrames=[Center-SignalBuffer,Center+SignalBuffer];
