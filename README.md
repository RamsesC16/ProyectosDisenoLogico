# Nombre del proyecto

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Ars
### 1.1 Descripción de proyecto y diagramas generales
El sistema desarrollado corresponde a un circuito digital orientado a la recuperación de información, implementado mediante el código de Hamming y descrito en SystemVerilog a partir de lógica combinacional. Su funcionamiento parte de dos entradas principales: una palabra de referencia y una palabra transmitida.

Mediante la aplicación del algoritmo de Hamming, el circuito comprueba la presencia de posibles errores en la palabra transmitida. Si se detecta un error de un solo bit, este se corrige automáticamente y la palabra resultante es decodificada para su visualización en un display de siete segmentos. Paralelamente, la palabra de referencia es mostrada en los LEDs de la FPGA, lo que permite realizar una comparación directa entre ambos valores.

Para organizar su diseño, el sistema se ha dividido en subsistemas funcionales, lo que facilita su construcción y comprensión. En términos generales, se identifican dos bloques principales:

Subsistema de procesamiento: encargado de la codificación, verificación, detección y corrección de errores, así como de la decodificación de las palabras según el algoritmo de Hamming.

Subsistema de visualización: responsable de presentar los resultados obtenidos en los dispositivos de salida (LEDs y displays de siete segmentos).

Finalmente, en la figura siguiente se ilustra el esquema de interconexión entre estos subsistemas.
<img width="1296" height="666" alt="image" src="https://github.com/user-attachments/assets/f6adce4b-153c-49e5-8a70-e31fabaa07b4" />
En el desarrollo del sistema, cada módulo se considera como un bloque de lógica combinacional, y su funcionamiento se organiza según la siguiente estructura de interconexión entre los distintos bloques:
<img width="1541" height="349" alt="image" src="https://github.com/user-attachments/assets/9cccb431-c14c-4315-b9b2-04cc50ba01a5" />
### 1.2 Desarrollo de los Módulos del Sistema



## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema

### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
