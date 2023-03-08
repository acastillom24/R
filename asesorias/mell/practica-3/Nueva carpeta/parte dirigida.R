#a) Examine la composici?n de datos faltantes. ?Que porcentaje hay por cada campo?
#?Visualiza alguna interacci?n? ?Hay faltantes en Criminalidad y Antiguedad a la vez?

base %>%  vis_miss()
base %>%  md.pattern()

#b) Determine la desviacion estandar, media, m?nimo y m?ximo de la variable Precio_Valor
# cuando hay y no hay datos faltantes en Criminalidad ?los grupos son muy diferentes?

base %>% 
  bind_shadow() %>% 
  group_by(Criminalidad_NA) %>%
  summarise_at(.vars = 
#c) Realice la imputaci?n por la media, la mediana y por KNN (vecinos m?s cercanos)
  
imputacion_media = base %>% impute_mean_all()
               imputacion_mediana = base %>% impute_median_all()
               imputacion_KNN = kNN(base)[,c(1:ncol(base))]
               Base_Procesada = imputacion_mediana
               hart.Correlation(Base_Procesada, histogram=TRUE, pch=19)
               ggplot(stack(Base_Procesada)) + aes(x=ind,y=values,fill=ind) + geom_boxplot()
               Base_Procesada %>% summarise_all(max,na.rm=T)
               Base_Procesada %>% summarise_all(min,na.rm=T)
               
               norm_minmax= as.data.frame(predict(preProcess(Base_Procesada,method=c("range")),Base_Procesada)) #realiza escalamiento entre 0 y 1 inclusive
               norm_minmax %>% summarise_all(max,na.rm=T)
               norm_minmax %>% summarise_all(min,na.rm=T)
               
               norm_boxcox = as.data.frame(normalize.decscale(Base_Procesada))
               norm_boxcox %>% summarise_all(max,na.rm=T)
               norm_boxcox %>% summarise_all(min,na.rm=T)
               
               norm_zscore= as.data.frame(predict(preProcess(Base_Procesada,method=c("center","scale")),Base_Procesada)) #realiza escalamiento restando media y dividiendo entre desv. est.
               norm_zscore %>% summarise_all(max,na.rm=T)
               norm_zscore %>% summarise_all(min,na.rm=T)
               
               norm_log= log10(Base_Procesada) #realiza escalamiento tomando el logaritmo en base 10 a todos los datos
               norm_log %>% summarise_all(max,na.rm=T)
               norm_log %>% summarise_all(min,na.rm=T)
               
               par(mfrow=c(1,5))
               
               boxplot(Base_Procesada,main="Base")
               boxplot(norm_minmax,main="Minmax")
               #boxplot(norm_boxcox,main="boxcox")
               boxplot(norm_zscore,main="zscore")
               boxplot(norm_log,main="log10")
               
               
               
               
               
               