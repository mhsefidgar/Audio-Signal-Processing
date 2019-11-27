# -*- coding: utf-8 -*-
"""
Created on Tue Nov 26 22:37:44 2019

@author: Moh
"""

import pydub
pydub.AudioSegment.converter = r"C:\Users\Moh\Desktop\Reports\Audio Analysis\PyaudioAnalysis\ffmpeg-20191126-59d264b-win64-static\bin\ffmpeg.exe"
from pyAudioAnalysis import audioBasicIO
from pyAudioAnalysis import ShortTermFeatures
import matplotlib.pyplot as plt
[Fs, x] = audioBasicIO.read_audio_file(r"C:\Users\Moh\Desktop\Reports\Speech Recognition\hands-on-markov-models-with-python-p2p_2\harvardConverted.wav")
F, f_names = ShortTermFeatures.feature_extraction(x, Fs, 0.050*Fs, 0.025*Fs)
F.shape 
plt.subplot(2,1,1); plt.plot(F[0,:]); plt.xlabel('Frame no'); plt.ylabel(f_names[0])
plt.subplot(2,1,2); plt.plot(F[1,:]); plt.xlabel('Frame no'); plt.ylabel(f_names[1]); plt.show()

