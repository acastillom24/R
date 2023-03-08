# Corroborar la versión de un paquete

```r
packageVersion("xfun")
```

# Actualizar los paquetes

```r
update.packages(ask = FALSE)
```

# Instalar una versión predeterminada de un paquete

```r
remotes::install_version("ggplot2", version = "0.9.1")
devtools::install_version("ggplot2", version = "0.9.1")
```

# Correr un file .r desde la consola

```
Rscript.exe c:\scripts\SayHi.r
```
