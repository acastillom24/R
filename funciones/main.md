## Lista de funciones
1. Formatear código SQL
1.1. Función
```R
SQL_format <- function(x){
  require(stringr)
  x <- str_remove_all(str_replace_all(str_replace_all(x, "[\t]", " "),"  ", " "), "[\n]")
  return(x)
}
```
1.2. Ejemplo
```R
query <- 
"
SELECT *
	FROM TRON2000.A2000030
		WHERE APELLIDOS = 'CASTILLO';
"

SQL_format(x = query)
```
Resultado
```
[1] "SELECT * FROM TRON2000.A2000030 WHERE APELLIDOS = 'CASTILLO';"
```
