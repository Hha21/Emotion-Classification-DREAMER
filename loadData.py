import scipy.io

class load_Data:

    def __init__(self):
        self.X = None
        self.Y = None
        self.Z = None
        self.freq = None
        self.channels = None
        self.ch_type = 'eeg'
        self.eegData = None
        self.use_autoreject = 'n'
    
    def load_arrays(self):
        data = scipy.io.loadmat('./DREAMER/DREAMER.mat')
        data = data['DREAMER']
        

loader = load_Data()
loader.load_arrays()


