# Emotion-Classification-DREAMER
Codebase for the purpose of emotion classification based on the [DREAMER](https://zenodo.org/records/546113) dataset.

## Version 1.0
preProcess.m processes DREAMER.mat into DREAMER_preprocessed.mat:
 - feature_matrix - 85744x42 - (42 = 18 electrodes x 3 frequency bands; theta, alpha, beta)
 - labels_matrix - 85744x3 - (3 = [valence, arousal, dominance])
   
N_examples = 85744. 23 participants x 18 experiments x no. windows
