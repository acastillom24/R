Repositorio personal para el desarrollo de técnicas estadísticas con el lenguaje de programación R.

# Apuntes

## Conocer la codificación de texto
´´´{r}
readr::guess_encoding(texto)
parse_character(, locale=locale(encoding="UTF-8"))
´´´

## Generar caracteres Unicode
´´´{r}
uranges <- Unicode::u_scripts()
expand_uranges <- lapply(uranges, as.u_char_seq)
all_unicode_chars <- unlist(expand_uranges)
´´´