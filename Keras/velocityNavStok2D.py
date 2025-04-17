import numpy as np
import matplotlib.pyplot as plt
from tensorflow import keras

# Cargar el modelo previamente entrenado y guardado
model = keras.models.load_model('fluid_model.keras',compile=False)

# Define el dominio especial (ajusta los limites el problema)
x_vals = np.linspace(-1, 1, 100)
y_vals = np.linspace(-1, 1, 100)
x_grid, y_grid = np.meshgrid(x_vals, y_vals)

# Si el modelo espera el tiempo (t), se puede fijar a cera para flujo estacionario
t_grid = np.zeros_like(x_grid)

# Prepara los datos de entrada para el modelo
inputs_grid = np.stack([x_grid.flatten(), y_grid.flatten(), t_grid.flatten()], axis=-1)

# Predice los valores de velocidad y presión
predictions = model.predict(inputs_grid)
u_pred = predictions[:, 0].reshape(x_grid.shape)
v_pred = predictions[:, 1].reshape(x_grid.shape)

# Si se quiere visualizar la presión, se puede hacer de la siguiente manera
p_pred = predictions[:, 2].reshape(x_grid.shape)

# Visualiza los resultados

plt.figure(figsize=(8, 6))
plt.quiver(x_grid, y_grid, u_pred, v_pred, scale=30)
plt.title('Campo de velocidades predicho')
plt.xlabel('x')
plt.ylabel('y')
plt.axis('equal')
plt.show()