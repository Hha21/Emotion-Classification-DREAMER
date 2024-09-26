%% --- Helper Script to just drop ECG data from DREAMER dataset ---

clear all 
clc

load('DREAMER.mat');

numParticipants = length(DREAMER.Data);

for i = 1:numParticipants
    if isfield(DREAMER.Data{1,i},'ECG')
        DREAMER.Data{1,i} = rmfield(DREAMER.Data{1,i},'ECG');
    end
end

save("DREAMER_no_ECG.mat",'DREAMER')
disp('ECG data removed and new file saved as DREAMER_no_ECG.mat');
