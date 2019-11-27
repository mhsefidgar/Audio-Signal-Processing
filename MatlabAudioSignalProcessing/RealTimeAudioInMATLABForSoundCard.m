%set up RT
 fileReader = dsp.AudioFileReader('Filename',fileInfo.Filename,...
     'SamplesPerFrame', frameSize);
 audioReader = audioDeviceReader('SampleRate', fileReader.SampleRate,...
      'Device', 'Scarlett 2i2 USB','SamplesPerFrame', frameSize);
%  audioReader = audioDeviceReader('SampleRate', fileReader.SampleRate,...
%       'Device', 'Pro Tools Aggregate I/O','SamplesPerFrame', frameSize);
%deviceWriter = audioDeviceWriter('SampleRate', fileReader.SampleRate,...
%  'Device', 'Built-in Output');
 
% deviceWriter = audioDeviceWriter('SampleRate', fileReader.SampleRate,...
%      'Device', 'Pro Tools Aggregate I/O','BufferSize', frameSize);
deviceWriter = audioDeviceWriter('SampleRate', fileReader.SampleRate,...
     'Device', 'Scarlett 2i2 USB','BufferSize', frameSize);
 
%deviceWriter = audioDeviceWriter('SampleRate', fileReader.SampleRate,...
%     'Device', 'Pro Tools Aggregate I/O');
 
%% Section C: Audio Stream Loop
ts=1/Fs;         % obtain sampling period
Vg=20;           % initialize Vg
Vk=0;            % initialize Vk
Vpk=0;           % initialize Vpk
 
%while ~isDone(fileReader) 
 
while(1)
    % Recieve Data
    %in = fileReader();
    in = audioReader();
    % Process Data
    Vin=in(:,1)/.55; % convert digital back to Voltage
    Vin=Gain*Vin;    % apply gain
    %[out, Vk, Vpk] = TriodeFunc(Vin, Fs, frameSize, Vg, Vk, Vpk);
    for k=1:frameSize
       % 1. Gather inputs
       as1(3)=Ro.get_reflected_wave(bs1(3));
       as1(2)=Co.get_reflected_wave(bs1(2));
       ap1(3)=ERp.get_reflected_wave(bp1(3),Vin(k));
       ap2(3)=Rk.get_reflected_wave(bp2(3));
       ap2(2)=Ck.get_reflected_wave(bp2(2));
 
       % 2. Wave up
       bs1=SeriesAdaptor(as1,[RS11 RS12 RS13]);
       ap1(2)=bs1(1,1);
 
       bp1=ParallelAdaptor(ap1,[RP11 RP12 RP13]);
       as2(2)=bp1(1,1);
 
       bp2=ParallelAdaptor(ap2,[RP11 RP12 RP13]);
       as2(3)=bp2(1,1);
 
       bs2=SeriesAdaptor(as2,[RS21 RS22 RS23]);
       Ta=bs2(1,1);
 
       % 3. Root (Triode Valve)
       Vgk=Vg-Vk;
       %    [Vpk, as2(1)] = newton_raphson_solver(Vpk, Vgk, Ta, RS21);
       [Vpk, as2(1)]=Triode(Ta, RS21, Vgk, Vpk);
       %debugVar(k)=as2(1);
 
       % 4. Wave down
       bs2=SeriesAdaptor(as2,[RS21 RS22 RS23]);
       ap2(1)=bs2(3); %
       ap1(1)=bs2(2); % 
 
 
       bp2=ParallelAdaptor(ap2,[RP21 RP22 RP23]);
       %bp2(3)=bp2(3); %
       %bp2(2)=bp2(2); %
 
       bp1=ParallelAdaptor(ap1,[RP11 RP12 RP13]);
       %bp1(3)=bp1(3); %
       as1(1)=bp1(2); %
 
       bs1=SeriesAdaptor(as1,[RS21 RS22 RS23]);
       %bs1(2)=bs1(2); %
       %bs1(3)=bs1(3); %
 
       % 5. Gather outputs
       Vk = Rk.wave_to_voltage();
       output(k) = Ro.wave_to_voltage();
 
       Ck.set_incident_wave(ap2(2)); % Only works if adaptor incident wave
       Co.set_incident_wave(as1(2)); % Only works if adaptor incident wave
 
    end
    %out=filter(Hhp,output);
    out=(output')*10000;
    %out = highpass(output,2*pi*10,Fs);
    %plot(out)
    % Write Data
    deviceWriter(out); 
 
end
