%% --- PreProcess.m - Process dropped DREAMER data ---

clear all
clc

load('DREAMER_no_ECG.mat');

theta_band = [4, 8];
alpha_band = [8, 13];
beta_band = [13, 20];

sample_rate = 128;

feature_matrix = [];
labels_matrix = [];

for participant_idx = 1:length(DREAMER.Data)
    participant = DREAMER.Data{1, participant_idx};
    
end