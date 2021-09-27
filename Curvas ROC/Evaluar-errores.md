## Evaluando el error de los modelos de clasificación

- Exactitud: Es el número de predicciones correctas realizadas por el modelo por el número total de registros.
  $$
  \frac{VP + VN}{VP + FP + FN + VN}
  $$

- Precisión: Es el desempeño de predicciones positivas.
  $$
  \frac{VP}{VP + FP}
  $$

- Sensibilidad: Llamada también Recall.
  $$
  \frac{VP}{VP + FN}
  $$

- Especificidad: Es la tasa negativa verdadera.
  $$
  \frac{VN}{VN+FP}
  $$

- Puntaje de F1: Promedio ponderado de precisión y sensibilidad.
  $$
  \frac{2\times Precisión \times Sensibilidad}{Precisión + Sensibilidad}
  $$
  

