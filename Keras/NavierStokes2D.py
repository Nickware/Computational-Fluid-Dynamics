import tensorflow as tf
from tensorflow import keras
import numpy as np

# Definir constantes fisicas
rho = 1.225 # kg/m^3 (Densidad del aire)
mu = 1.81e-5 # Pa.s (Viscosidad dinamica del aire)
nu = mu/rho # Viscosidad cinemática (m^2/s)

#Definir la arquitectura de la red neuronal
model = keras.Sequential([
    keras.layers.Dense(units=64, activation='tanh', input_shape=(3,)),
    keras.layers.Dense(units=64, activation='tanh'),
    keras.layers.Dense(3)])

# Funcion perdida fisica
def physics_loss(y_true, y_pred):
    # Definir la funcion de perdida fisica
    # En este caso, la funcion de perdida es simplemente la diferencia entre la salida de la red y el valor esperado
    x, y, t = tf.split(y_true, 3, axis=1) #Suponiendo que y_true contiene (x,y,z)
    u, v, p = tf.split(y_pred, 3, axis=1) #Suponiendo que y_true contiene (u,v,p)

# Calculo de las derivadas GradientTape
    with tf.GradientTape(persistent=True) as tape:
        tape.watch([x, y, t])
        outputs = model(tf.concat([x, y, t], axis=1))
        u, v, p = tf.split(outputs, 3, axis=1) #Suponiendo que y_true contiene (u,v,p)

    # Derivadas primeras
        u_x = tape.gradient(u, x)
        u_y = tape.gradient(u, y)
        v_x = tape.gradient(v, x)
        v_y = tape.gradient(v, y)
        p_x = tape.gradient(p, x)
        p_y = tape.gradient(p, y)

    # Derivadas segundas
        u_xx = tape.gradient(u_x, x)
        u_yy = tape.gradient(u_y, y)
        v_xx = tape.gradient(v_x, x)
        v_yy = tape.gradient(v_y, y)

    # Ecuación de continuidad (incompresible)
        continuity_eq = u_x + v_y

    # Ecuación de momento (simplificada para el flujo estacionario)
        #momentum_x = u * u_x + v * u_y + (1/rho) * p, x - nu * (u_xx + u_yy)
        #momentum_y = u * v_x + v * v_y + (1/rho) * p, y - nu * (v_xx + v_yy)
        momentum_x = u * u_x + v * u_y + (1/rho) * p_x - nu * (u_xx + u_yy)
        momentum_y = u * v_x + v * v_y + (1/rho) * p_y - nu * (v_xx + v_yy)

# Perdida total
    loss = (
        tf.reduce_mean(continuity_eq**2) + # Ecuación de continuidad
        tf.reduce_mean(momentum_x**2) + # Ecuación de momento en x
        tf.reduce_mean(momentum_y**2) # Ecuación de momento en y
    )
    return loss

# Generar datos de entrenamiento (coordenadas espaciales y temporales)
x = np.random.uniform(-1, 1,1000)
y = np.random.uniform(-1, 1,1000)
t = np.zeros_like(x) # flujo estacionario
inputs = np.vstack((x, y, t)).T

# Condicopnes de frontera (ejemplo: velocidad de entrada)

def boundary_conditions(x, y):
    return np.where(x < -0.9, 1.0, 0.0) # flujo uniforme en la entrada

u_bc = boundary_conditions(x, y)
v_bc = np.zeros_like(x) # velocidad cero en la entrada
p_bc = np.zeros_like(x) # presion cero en la entrada

# Compilar el modelo
model.compile(optimizer='adam', loss=physics_loss)

# Entrenar el modelo
model.fit(inputs, np.vstack((u_bc, v_bc, p_bc)).T, epochs=500, batch_size=32)

# Guardar el modelo
model.save('fluid_model.keras')
# Cargar el modelo
#loaded_model = keras.models.load_model('fluid_model.h5', custom_objects={'physics_loss': physics_loss})
# Evaluar el modelo
#x_test = np.random.uniform(-1, 1, 100)
#y_test = np.random.uniform(-1, 1, 100)
#t_test = np.zeros_like(x_test) # flujo estacionario
#inputs_test = np.vstack((x_test, y_test, t_test)).T
#outputs_test = loaded_model.predict(inputs_test)