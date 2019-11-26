function [player,Fs] =  AudioUpsample(AudioFilePath,UpsamplingRate)
%% Powered by Mohammad Sefidgar
%% Reading Audio Data
[y,Fs] = audioread(AudioFilePath);

%% Checking the Number of channel 
    if size(y,2)==2
        y1=y(:,1);
        y=zeros(size(y));
        y=y1;
    end
    
%% Interpolation of audio signal 
% Please be informed that the maximum sampeling rate depends of your
% computer audio card.

A=interp(y(:,1),UpsamplingRate);
Fs1=Fs*UpsamplingRate;
player = audioplayer(A,Fs1);


end