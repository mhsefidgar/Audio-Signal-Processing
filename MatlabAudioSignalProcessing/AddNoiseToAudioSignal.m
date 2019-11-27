% Open standard demo sound that ships with MATLAB.
[perfectSound, freq] = audioread('harvard.wav');
% Add noise to it.
noisySound = perfectSound + 0.01 * randn(length(perfectSound), 1);
% Find out which sound they want to play:
promptMessage = sprintf('Which sound do you want to hear?');
titleBarCaption = 'Specify Sound';
button = questdlg(promptMessage, titleBarCaption, 'Perfect', 'Noisy', 'Perfect');
if strcmpi(button, 'Perfect')
  % Play the perfect sound.
  soundsc(perfectSound, freq);
else
  % Play the noisy sound.
  soundsc(noisySound, freq);
end
