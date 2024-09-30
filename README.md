# Emotion-Classification-DREAMER
Codebase for the purpose of emotion classification based on the [DREAMER](https://zenodo.org/records/546113) dataset.

## Version 1.0
preProcess.m processes DREAMER.mat into DREAMER_preprocessed.mat:
 - feature_matrix - 85744x42 - (42 = 18 electrodes x 3 frequency bands; theta, alpha, beta)
 - labels_matrix - 85744x3 - (3 = [valence, arousal, dominance])
   
N_examples = 85744. 23 participants x 18 experiments x no. windows

## Files
```
----\DREAMER\ 
         -- ICAremoval.m : MATLAB Script for performing ICA analysis for artifact removal
         -- Screenshot 2024-09-30 171546.png : (SAMPLE ICA IMAGE)
         -- posact.m : [Swartz Centre for Computational Neuroscience](https://sccn.ucsd.edu/~arno/eeglab/auto/posact.html)
         -- preProcess.m: PreProcess DREAMER dataset into format for following ML model (current implementation just feed-forward)
         -- runica.m : [Swartz Centre for Computational Neuroscience](https://sccn.ucsd.edu/~jung/tutorial/runica.htm) 

----\Model.py : Class for creating Simple_Model object, with current implementation just being a feed-forward network

----\emotion_classification_model.h5 : Sample Model
```
