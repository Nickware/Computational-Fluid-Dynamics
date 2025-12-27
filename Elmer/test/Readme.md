# Problema 2D de **conducción** estacionaria en una placa cuadrada

Un caso desde cero usando ElmerGUI: un problema 2D de **conducción** estacionaria en una placa cuadrada, con un lado caliente y el opuesto frío (ecuación de calor en estado estacionario).[nic.funet+1](https://www.nic.funet.fi/index/elmer/doc/ElmerTutorials.pdf)

## Problema que se va implementar

- Dominio: cuadrado 1 m × 1 m.
- Ecuación: Heat Equation (steady state, sin fuentes internas).
- Condiciones de contorno:
  - Lado izquierdo: $T = 100$ °C.
  - Lado derecho: $T = 0$ °C.
  - Lados superior e inferior: flujo cero (aislados).
- Objetivo: visualizar el campo de temperatura en la placa.[indico.ijs+1](https://indico.ijs.si/event/1354/sessions/184/attachments/1159/1508/Guided_examples_using_elmerfem.pdf)

------

## Paso 1: Malla sencilla del cuadrado

Se puede usar Gmsh, FreeCAD o una malla ya hecha; lo más simple es:

- Crear una malla 2D de un cuadrado $[0,1] \times [0,1]$ y guardarla como `square.msh` (Gmsh) o en formato aceptado por Elmer.
- Convertirla con ElmerGrid (si hace falta):
  - `ElmerGrid 14 2 square.msh -out square`
  - Esto crea un directorio `square` con la malla en formato de Elmer.[nic.funet+1](https://www.nic.funet.fi/index/elmer/doc/ElmerGUIManual.pdf)

Si ya se tiene alguna malla de ejemplo, se puede reutilizar; solo importa que sea un dominio 2D sencillo con un único cuerpo.

------

## Paso 2: Crear proyecto en ElmerGUI

1. Abrir ElmerGUI.
2. Menú **File → New project...**.
3. Eligir carpeta del proyecto (por ejemplo `C:\Elmer\proyectos\Placa2D`).
4. En “Elmer mesh directory”, selecciona la carpeta de la malla (`square`).
5. Aceptar para cargar la malla.[nic.funet](https://www.nic.funet.fi/index/elmer/doc/ElmerGUIManual.pdf)

Se deberá ver el cuadrado en la ventana gráfica; conviene rotar/zoom para comprobar que se ve bien y que hay un solo **Body** en el menú de malla.[nic.funet](https://www.nic.funet.fi/index/elmer/doc/ElmerGUIManual.pdf)

------

## Paso 3: Definir el modelo físico

1. Menú **Model → Setup...**
   - Simulation type: **Steady state**.
   - Output file: por ejemplo `case`.
   - Deja el resto por defecto y pulsa OK.[nic.funet+1](https://www.nic.funet.fi/index/elmer/doc/ElmerModelsManual.pdf)
2. Menú **Model → Equations... → Add**
   - Marcar **Heat Equation**.
   - Dejar “Active” y “Apply to all bodies”.
   - OK, y luego **Apply** para asociarla al único Body.[indico.ijs+1](https://indico.ijs.si/event/1354/sessions/184/attachments/1159/1508/Guided_examples_using_elmerfem.pdf)
3. Menú **Model → Materials... → Add**
   - Crea un material sencillo:
     - Heat Conductivity: 1.0
     - Heat Capacity: 1.0 (aunque no afecta mucho en estacionario).
     - Density: 1.0
   - OK, y **Apply** al cuerpo.[nic.funet+1](https://www.nic.funet.fi/index/elmer/doc/ElmerModelsManual.pdf)

No hace falta Body Force porque no habrá fuente de calor volumétrica en este test.[indico.ijs](https://indico.ijs.si/event/1354/sessions/184/attachments/1159/1508/Guided_examples_using_elmerfem.pdf)

------

## Paso 4: Condiciones de contorno

1. Menú **Model → Boundary conditions... → Add**
   - Condición 1 – lado caliente:
     - Name: `HotSide`.
     - En pestaña **Heat Equation**, marca **Temperature** y pon `100.0`.
     - OK.
     - Luego, en la ventana de malla, selecciona el lado izquierdo (se puede usar “Set boundary properties” o doble clic en el número de frontera asociado) y asigna `HotSide`.[arek.pajak+1](https://www.arek.pajak.info.pl/wp-content/uploads/2013/09/ElmerTutorials.pdf)
2. Condición 2 – lado frío:
   - Add de nuevo:
     - Name: `ColdSide`.
     - Temperature = `0.0`.
     - OK, y asígnala al lado derecho.[arek.pajak+1](https://www.arek.pajak.info.pl/wp-content/uploads/2013/09/ElmerTutorials.pdf)
3. Condición 3 – lados aislados:
   - Add:
     - Name: `Insulated`.
     - No definir Temperature; dejar el flujo por defecto (que es Neumann cero → flujo de calor nulo).
     - OK, y asígnalar al borde superior e inferior.[arek.pajak+1](https://www.arek.pajak.info.pl/wp-content/uploads/2013/09/ElmerTutorials.pdf)

------

## Paso 5: Guardar, generar SIF y ejecutar

1. Menú **File → Save project** para guardar el proyecto.
2. Botón de la barra “Generate, save and run” (doble triángulo verde) o:
   - Menú **Run → Start solver** después de **Run → Generate**.
3. Comprobar que el solver termina sin errores en la ventana de log.[nic.funet+1](https://www.nic.funet.fi/index/elmer/doc/ElmerModelsManual.pdf)

------

## Paso 6: Visualizar resultados

- Desde ElmerGUI:
  - Menú **Run → Start ParaView** o **Start ElmerVTK** (según se tenga instalado).
  - Carga el archivo de resultado (por ejemplo `case.vtu`) y visualizar el campo de temperatura como un mapa de colores.[nic.funet+1](https://www.nic.funet.fi/index/elmer/doc/GetStartedElmer.pdf)

Se deberá ver un gradiente de temperatura desde 100 °C (lado caliente) hasta 0 °C (lado frío), aproximadamente lineal en el interior por lo simple del problema.youtube[indico.ijs](https://indico.ijs.si/event/1354/sessions/184/attachments/1159/1508/Guided_examples_using_elmerfem.pdf)

------

1. https://www.nic.funet.fi/index/elmer/doc/ElmerTutorials.pdf
2. https://indico.ijs.si/event/1354/sessions/184/attachments/1159/1508/Guided_examples_using_elmerfem.pdf
3. https://www.nic.funet.fi/index/elmer/doc/ElmerModelsManual.pdf
4. https://www.nic.funet.fi/index/elmer/doc/ElmerGUIManual.pdf
5. https://www.arek.pajak.info.pl/wp-content/uploads/2013/09/ElmerTutorials.pdf
6. https://www.nic.funet.fi/index/elmer/doc/GetStartedElmer.pdf
7. https://www.youtube.com/watch?v=C42MR4WkJd4
8. https://www.dma.uvigo.es/files/cursos/elmer2/Manuales/ElmerTutorials.pdf
9. https://www.youtube.com/playlist?list=PL138064B3BA4ECB59
10. https://ftp.csc.fi/index/elmer/courses/cource_may2010/ElmerGUITutorials_May2010.pdf
11. https://www.youtube.com/watch?v=XfHqaq2bbgU
12. https://www.elmerfem.org/forum/viewtopic.php?p=8814
13. https://www.elmerfem.org/forum/viewtopic.php?p=13976
14. https://forum.freecad.org/viewtopic.php?t=56855
15. https://www.youtube.com/watch?v=S6OjQGh-iB4
16. [https://fvs.com.py/_pdfs/uploaded-files/3tlkpF/Elmer%20An%20Open%20Source%20Finite%20Element%20Software%20For.pdf](https://fvs.com.py/_pdfs/uploaded-files/3tlkpF/Elmer An Open Source Finite Element Software For.pdf)
17. https://tehnick.github.io/elmer/compilation.html
18. https://www.youtube.com/watch?v=ZYtoB-CBxhU
19. https://github.com/ElmerCSC/elmerfem/issues/201
20. https://forum.freecad.org/viewtopic.php?t=52767
