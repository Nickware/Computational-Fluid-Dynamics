# Simulación de Impacto y Deformación con Enlaces Rompibles

Este script es un archivo de entrada para **LAMMPS** que configura y ejecuta una simulación molecular dinámica en 3D con partículas enlazadas mediante potenciales tipo resorte que pueden romperse. Se modela un sistema formado por dos grupos principales:

- **Plate (Placa):** un conjunto de átomos en forma de disco cilíndrico, enlazados para representar un sólido o material con estructura.
- **Projectile (Proyectil):** un agrupamiento esférico de átomos, también enlazados, que se mueve hacia la placa con una velocidad inicial prefijada.

---

## Secciones Clave y Funcionalidades

### 1. Definición del Entorno de Simulación
- **Unidades Lennard-Jones (LJ):** unidades reducidas típicas para estudiar propiedades generales sin unidades físicas específicas.
- **Caja de simulación 3D** con límites fijos (no periódicos), cubriendo una región definida alrededor del plano y el volumen del proyectil.
- **Estilo de átomo con enlaces (bond)** permite modelar interacciones no solo entre átomos, sino también mediante enlaces dinámicos.

### 2. Generación de Átomos y Agrupamientos
- Se crea una **placa** como un cilindro delgado de átomos distribuidos en un plano.
- Se crea un **proyectil** como una esfera sólida de átomos.
- Ambos grupos se enlazan internamente mediante un potencial de resorte con capacidad de ruptura, simulando materiales cohesionados.

### 3. Configuración de Enlaces y Potenciales
- Los enlaces tienen diferentes umbrales de ruptura, permitiendo modelar comportamiento mecánico diferenciado entre la placa y el proyectil.
- La interacción entre átomos aislados usa un potencial especializado **bpm/spring**, que controla tanto la fuerza de enlace como el posible rompimiento.

### 4. Movimiento y Dinámica
- El proyectil recibe una velocidad inicial para simular un impacto contra la placa.
- Integra el sistema en el ensamble NVE (energía constante), permitiendo observar la evolución natural del sistema.

### 5. Monitoreo y Salida
- Computa el número de enlaces totales y por átomo para seguir la evolución de la ruptura.
- Se imprimen propiedades termodinámicas clave (energías, presiones, enlaces) con posibilidad de activar dump files para análisis detallados.

---

## Oportunidades y Potencialidades

Este script ofrece una base versátil para múltiples tipos de estudios computacionales, gracias a su modelado explícito de enlaces rompibles y estructuras definidas:

### 1. **Simulaciones de Fractura y Deformación Mecánica**
- Muy útil para analizar la **resistencia y propagación de grietas** en materiales sólidos.
- Permite estudiar cómo se comportan diferentes regiones de material con propiedades distintas (e.g., placa vs proyectil).
- La parametrización de ruptura abierta puede ajustarse para simular materiales desde frágiles hasta dúctiles.

### 2. **Estudios de Impacto y Dinámica de Colisiones**
- Puede modelar eventos dinámicos donde un objeto choca y deforma o rompe otro, útil en investigaciones sobre materiales balísticos o protección.
- Se puede modificar la velocidad, tamaño y forma del proyectil para explorar diferentes escenarios de impacto.

### 3. **Materiales Compuestos y Multi-fásicos**
- Adaptando la creación de regiones y tipos de enlaces, se pueden simular materiales con diferentes fases o inclusiones.
- Por ejemplo, añadir regiones con enlaces más débiles para simular materiales heterogéneos o defectos.

### 4. **Dinámica de Redes y Polímeros**
- El enfoque de enlaces dinámicos y rompibles se presta para estudiar cadenas poliméricas, donde enlaces pueden romperse y reformarse.
- Ampliable para introducir enlaces con distinta mecánica, simulando distintos tipos de enlaces químicos o físicos.

### 5. **Simulaciones Termomecánicas**
- Incorporando termostatos o deformaciones externas se puede estudiar cómo cambia la resistencia a la fractura con temperatura o estrés aplicado.
- Cambiando el ensamble y conditions, puede investigar fatiga o envejecimiento de materiales.

### 6. **Desarrollo y Validación de Potenciales Personalizados**
- Usar o extender el pare_style `bpm/spring` permite desarrollar nuevos modelos de interacción que incluyan características específicas, como deformación plástica o viscoplasticidad.
- Este script es un excelente punto de partida para validar esos potenciales en geometrías simples.

---

## Resumen

Este Implementación es una herramienta poderosa para simular sistemas con estructuras enlazadas sujetas a deformación y ruptura bajo cargas dinámicas. Su estructura modular permite adaptarlo a múltiples escenarios físicos, desde mecánica de sólidos, materiales compuestos, hasta fenomenología de fractura y colisiones. Con modificaciones, puede ser usado en investigación fundamental o aplicada, así como en la enseñanza de conceptos de mecánica computacional de materiales.

