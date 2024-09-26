import numpy as np
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from scipy.io import loadmat

class Simple_Model:

    def __init__(self):

        self.data = loadmat('.\DREAMER\DREAMER_preprocessed.mat')

        feature_matrix = self.data['feature_matrix']
        labels_matrix = self.data['labels_matrix']

        X_train, X_test, y_train, y_test = train_test_split(feature_matrix, labels_matrix, test_size=0.2, random_state=42)

        scaler = StandardScaler()
        X_train = scaler.fit_transform(X_train)
        X_test = scaler.transform(X_test)

        self.model = self.create_model(X_train.shape[1])

        self.model.compile(optimizer='adam',
                            loss = 'mean_squared_error',
                            metrics = ['mean_absolute_error'])
        
        self.model.summary()

        self.history = self.model.fit(X_train, y_train,
                                    validation_data = (X_test, y_test),
                                    epochs = 50,
                                    batch_size = 32,
                                    verbose = 1)
        
        test_loss, test_mae = self.model.evaluate(X_test, y_test, verbose = 0)
        print(f'Test Loss: {test_loss:.4f}')
        print(f"Test MAE: {test_mae:.4f}")

        self.model.save('emotion_classification_model.h5')

        self.plots()



    def create_model(self, input_dim):
        model = tf.keras.models.Sequential([
            tf.keras.layers.InputLayer(input_shape = (input_dim,)),
            tf.keras.layers.Dense(64, activation = 'relu'),
            tf.keras.layers.Dropout(0.5),
            tf.keras.layers.Dense(32, activation = 'relu'),
            tf.keras.layers.Dropout(0.5),
            tf.keras.layers.Dense(16, activation = 'relu'),
            tf.keras.layers.Dense(3, activation = 'linear')
        ])
        return model   

    def plots(self):
        plt.figure(figsize=(12, 6))
        plt.subplot(1, 2, 1)
        plt.plot(self.history.history['loss'], label='Train Loss')
        plt.plot(self.history.history['val_loss'], label='Validation Loss')
        plt.title('Model Loss')
        plt.xlabel('Epochs')
        plt.ylabel('Loss (MSE)')
        plt.legend()

        plt.subplot(1, 2, 2)
        plt.plot(self.history.history['mean_absolute_error'], label='Train MAE')
        plt.plot(self.history.history['val_mean_absolute_error'], label='Validation MAE')
        plt.title('Model Mean Absolute Error')
        plt.xlabel('Epochs')
        plt.ylabel('MAE')
        plt.legend()

        plt.show() 
        

model = Simple_Model()



