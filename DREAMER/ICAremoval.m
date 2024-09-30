function ICAremoval()
    
    load('DREAMER.mat');
    
    participant_num = input('Enter Participant Number (1-23): ');
    experiment_num = input('Enter Experiment Number (1-18): ');
    
    % DREAMER.Data{1,PARTICIPANT}.EEG.stimuli{EXPNUM,1}(:,ELECTRODE)

    eeg_data = DREAMER.Data{1, participant_num}.EEG.stimuli{experiment_num, 1};
    eeg_data = eeg_data';   %[channels x timepoints]
    [weights, sphere] = runica(eeg_data);
    ica_signals = weights * sphere * eeg_data;
    npoints = size(ica_signals, 2);

    figure;
    for i = 1:14
        subplot(7, 2, i);
        plot(linspace(0,npoints/128,npoints),ica_signals(i, :));
        title(['ICA Component ', num2str(i)]);
        xlabel('Time (s)')
    end

    artifact_input = input('Enter the artifact component numbers (e.g., [2, 4, 6]): ');
    disp(size(artifact_input))
    
    
    %ica_signals(artifact_input, :) = 0;

    cleaned_eeg = weights \ ica_signals;
    cleaned_eeg = cleaned_eeg';

    eeg_data = DREAMER.Data{1, participant_num}.EEG.stimuli{experiment_num, 1};

    figure;
   
    for ch = 1:14
        subplot(7, 2, ch);
        plot(linspace(0,npoints/128,npoints),eeg_data(:, ch), 'b');  % Original EEG in blue
        hold on;
        plot(linspace(0,npoints/128,npoints),cleaned_eeg(:, ch), 'r');  % Cleaned EEG in red
        title(['Channel ', num2str(ch), ' (Blue: Original, Red: Cleaned)']);
        xlabel('Time (s)')
    end

    keep_changes = input('Do you want to keep the changes? (y/n): ', 's');

    if strcmpi(keep_changes, 'y')
        % Save the cleaned EEG data if the user confirms
        filename = ['cleaned_eeg_participant_', num2str(participant_num), '_experiment_', num2str(experiment_num), '.mat'];
        save(filename, 'cleaned_eeg');
        disp(['Cleaned EEG data saved to ', filename]);
    else
        disp('Changes discarded. Cleaned data was not saved.');
    end


end

