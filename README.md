Repositorio personal para el desarrollo de técnicas estadísticas con el lenguaje de programación R.

## Apuntes

### Conocer la codificación de texto

```r
readr::guess_encoding(texto)
parse_character(, locale=locale(encoding="UTF-8"))
```

### Generar caracteres Unicode

```r
uranges <- Unicode::u_scripts()
expand_uranges <- lapply(uranges, as.u_char_seq)
all_unicode_chars <- unlist(expand_uranges)
```

## Instalar versiones anteriores de los paquetes

### Usando devtools

```r
require(devtools)
install_version("ggplot2", version = "0.9.1", repos = "http://cran.us.r-project.org")
```

### Usando una dirección

```r
packageurl <- "http://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_0.9.1.tar.gz"
install.packages(packageurl, repos=NULL, type="source")
```

### Usando línea de comandos

```r
wget http://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_0.9.1.tar.gz
R CMD INSTALL ggplot2_0.9.1.tar.gz
```

## Personalizar RStudio

- [Dracula](https://draculatheme.com/rstudio)

- [Synthwave85](https://github.com/jnolis/synthwave85)

- [Darkstudio](https://rileytwo.github.io/darkstudio/)

- [Rscodeio](https://github.com/anthonynorth/rscodeio)

- [Rsthemes](https://www.garrickadenbuie.com/project/rsthemes/)

- [RStudio themes](https://github.com/mkearney/rstudiothemes)