# K-Means

- Es un Método Estadístico Multivariante de clasificación automática - Jerárquico.
- Es una Técnica Estadística de Clasificación y segmentación.

## Objetivo: 

Identificar grupos de sujetos lo más heterogéneos posible entre sí y lo más homogéneo dentro de cada grupo, basándose en la similitud de características especificadas previamente.

## Finalidad: 

Revelar concentraciones en los datos, basados principalmente en la proximidad o lejanía de unos con otros.

## Consideraciones: 

- Variables de aglomeración en escalas distintas, debe ser necesario estandarizar o trabajar con desviaciones respecto de la media.

- Observaciones perdidas, se debe eliminar o imputar previamente ya que los métodos jerárquicos no tienen solución con valores perdidos.

- Valores atípicos, deforman las distancias y producen clusters unitarios.

- Variables correlacionadas, requiere un análisis de multicolinealidad previo.

- Los grupos no se conocen previamente (post hoc) , pero son sugeridos por la esencia de los datos.

- Número de elementos en cada cluster, debe ser relevante.

- Conglomerados, deben tener sentido conceptual y no variar de forma significativa, al variar la muestra o el método de aglomeración.

- La solución, no tiene porque ser única, pero no deben existir soluciones contradictorias por distintos métodos.

## Pasos fundamentales en la elaboración de conglomerados:
- Los coeficientes de similitud o disimilitud, entre los nuevos conglomerados establecidos y los candidatos a ser admitidos se recalculan en cada etapa.
- El criterio de admisión de nuevos miembros a un conglomerado ya establecido.

## Algoritmo:

1. Seleccionar el número de Clusters K

2. Seleccionar aleatoriamente K puntos (No necesariamente puntos del conjunto de datos). Estos son los centroides.

3. Asignar cada valor del conjunto de datos a su centroide más cercano. Formando K Clusters (Grupos)

4. Desplaza el centroide de cada cluster y recalcula las distancias

5. Reasigna cada punto a su centroide más cercano. Si existe alguna re-asignación, regresa al paso 4, sino, termina el algoritmo. 

## K-Means plus plus
Algoritmo utilizado para seleccionar los valores iniciales de los centroides.

### Algoritmo:

1. Seleccionar el primer centroide aleatoriamente escogiendo un valor del conjunto de datos.

2. Calcula la distancia $D(x)$ de cada punto x con este centroide.

3. Escoge un nuevo centroide utilizando una distribución de probabilidad ponderada para $D^2(x)$.

4. Repite los pasos 2 y 3 hasta seleccionar los k centroides.

## Número correcto para elegir el número correcto de clusters.

- WCSS: Suma total de la distancia de cada dato con el centroide.

## Información Adicional
- [Jacob Avila Camacho: K Means Clustering 👉](https://www.youtube.com/watch?v=SwVCfiJNfwg)