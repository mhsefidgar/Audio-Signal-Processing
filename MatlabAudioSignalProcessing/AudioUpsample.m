function [player,Fs] =  AudioUpsample(AudioFilePath,UpsamplingRate)
%% Powered by Mohammad Sefidgar
%% Reading Audio Data
[y,Fs] = audioread(AudioFilePath);
%% checking Upsampeling rate 
    if UpsamplingRate>3
        error('please consider UpsamplingRate of 2 or 3')
        return;
    end

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