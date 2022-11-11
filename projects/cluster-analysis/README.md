# ¿Clasificación? ¿Clustering? ¿Conglomerados?

La clasificación consiste en determinar la clase al cual pertenece un registro de la BD.

Cuando se realiza el procedimiento de clasificar se pueden emplear técnicas dependiendo del tipo de clasificación... a los grupos formados al clasificar se les denomina **clusters** o **conglomerados**.

## Tipos de clasificación:

### Clasificación no supervisada
Cuando el objetivo es la clasificación o formación de grupos sin tener **una variable target**.

- Clustering, involucra diferentes algoritmos como k-medias, k-mediodes y método gaussiano.
- Métodos jerárquicos.

#### K-Medias o K-Means
##### Objetivo: 
Identificar grupos de sujetos lo más heterogéneos posible entre sí y lo más homogéneos dentro de cada grupo, basándose en el criterío de similitud o disimilitud de características especificadas previamente.

##### Consideraciones: 
- Observaciones perdidas, se debe eliminar o imputar previamente.
- Valores atípicos, deforman las distancias y producen clusters unitarios.
- Cuando las variables de aglomeración esten en escalas distintas, debe ser necesario estandarizar o trabajar con desviaciones respecto de la media.
- Requiere un análisis de multicolinealidad previo, para evitar tener variables correlacionadas.
- Los grupos no se conocen previamente (post hoc), pero son sugeridos por la esencia de los datos.
- El número de elementos en cada cluster, debe ser relevante.
- Los conglomerados finales, deben tener sentido conceptual y no variar de forma significativa al variar la muestra o el método de aglomeración.
- La solución, no tiene porque ser única, pero no deben existir soluciones contradictorias por distintos métodos.

##### Pasos fundamentales en la elaboración de conglomerados:
- Los coeficientes de similitud o disimilitud, entre los nuevos conglomerados establecidos y los candidatos a ser admitidos se recalculan en cada etapa.
- El criterio de admisión de nuevos miembros a un conglomerado ya establecido.

##### Algoritmo:
1. Seleccionar el número de Clusters K
2. Seleccionar aleatoriamente K puntos (No necesariamente puntos del conjunto de datos). Estos son los centroides.
3. Asignar cada valor del conjunto de datos a su centroide más cercano. Formando K Clusters (Grupos).
4. Desplaza el centroide de cada cluster y recalcula las distancias.
5. Reasigna cada punto a su centroide más cercano. Si existe alguna re-asignación, regresa al paso 4, sino, termina el algoritmo. 

##### Algoritmo: K-Means plus plus
Algoritmo utilizado para seleccionar los valores iniciales de los centroides.

1. Seleccionar el primer centroide aleatoriamente escogiendo un valor del conjunto de datos.
2. Calcula la distancia $D(x)$ de cada punto x con este centroide.
3. Escoge un nuevo centroide utilizando una distribución de probabilidad ponderada para $D^2(x)$.
4. Repite los pasos 2 y 3 hasta seleccionar los k centroides.

##### Número correcto para elegir el número correcto de clusters.
- WCSS: Suma total de la distancia de cada dato con el centroide.

### Clasificación supervisada
Cuando el objetivo es la clasificación o formación de grupos teniendo **una variable target**.

Se debe dividir la base de datos en entrenamiento y evaluación y asignar los registros a una determinada clase de la target empleando las variables input disponibles de la **manera mas precisa**. Llamado tambien proceso de decisión y la regla se denomina **clasificador**.

- Análisis de Discriminante Lineal.
- Naive Bayes.
- K Vecinos mas cercanos.
- Árboles de decisión.

#### Análisis discriminante lineal.
- Separa en dos o mas clases.
- Emplea una combinación lineal de variables.

Es una generalización del discriminante lineal de Fisher, usado para hallar combinaciones lineales de variables que separan en dos o mas clases a las instancias o registros.
La combinación resultante es usada como un clasificador lineal o mas comúnmente para reducción dimensionar antes de clasificar.
Es una técnica que se emplea con variables input (independientes) continuas y una variable target (dependiente) categórica.

##### Supuestos del LDA
- Normalidad multivariada
- Homocedasticidad
- Multicolinealidad
- Independencia

#### K Vecinos mas cercanos.
Algoritmo no parámetrico.
