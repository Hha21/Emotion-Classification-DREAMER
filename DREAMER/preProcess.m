%% --- PreProcess.m - Process dropped DREAMER data ---

clear all
clc

load('DREAMER.mat');

theta_band = [4, 8];
alpha_band = [8, 13];
beta_band = [13, 20];

sample_rate = 128;

feature_matrix = [];
labels_matrix = [];

for participant_idx = 1:length(DREAMER.Data)
    disp(participant_idx)
    participant = DREAMER.Data{1, participant_idx};
    for experiment_idx = 1:18
        baseline_data = participant.EEG.baseline{experiment_idx, 1};
        stimuli_data = participant.EEG.stimuli{experiment_idx, 1};

        baseline_psd_log = compute_log_psd(baseline_data, sample_rate, theta_band, alpha_band, beta_band);
        num_samples = size(stimuli_data, 1);
        window_size = sample_rate;  %1s Window
        step_size = sample_rate;    %No Overlap
        num_windows = floor((num_samples - window_size) / step_size) + 1; 

        for window_idx = 1:num_windows
            start_idx = (window_idx - 1)*step_size + 1;
            end_idx = start_idx + window_size - 1;
            window_data = stimuli_data(start_idx:end_idx, :);
            window_psd_log = compute_log_psd(window_data, sample_rate, theta_band, alpha_band, beta_band);

            corrected_psd_log = window_psd_log - baseline_psd_log;

            feature_vector = reshape(corrected_psd_log, 1, []);
            feature_matrix = [feature_matrix; feature_vector];

            valence = participant.ScoreValence(experiment_idx);
            arousal = participant.ScoreArousal(experiment_idx);
            dominance = participant.ScoreDominance(experiment_idx);

            labels_matrix = [labels_matrix; [valence, arousal, dominance]];
        end
    end
end

save('DREAMER_preprocessed.mat', 'feature_matrix', 'labels_matrix');
disp('Preprocessing complete and data saved.')


function log_psd = compute_log_psd(eeg_data, sample_rate, theta_band, alpha_band, beta_band)
    num_channels = size(eeg_data, 2);
    log_psd = zeros(3, num_channels);

    for channel_idx = 1:num_channels
        [pxx, f] = pwelch(eeg_data(:,channel_idx), sample_rate, [], [], sample_rate);
        log_psd(1, channel_idx) = log_band_power(pxx, f, theta_band);
        log_psd(2, channel_idx) = log_band_power(pxx, f, alpha_band);
        log_psd(3, channel_idx) = log_band_power(pxx, f, beta_band);
    end
end

function log_power = log_band_power(pxx, f, band)
    band_idx = find(f >= band(1) & f <= band(2));
    band_power = sum(pxx(band_idx));
    log_power = log(band_power);
end