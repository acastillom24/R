## Lista de funciones
### Formatear código SQL  

1.1 Función
Esta función se en la regla de sintaxis la cual indica que tanto los espacios en blanco y las múltiples líneas son ignoradas en SQL.

```R
SQL_format <- function(x){
  require(stringr)
  x <- str_replace_all(str_replace_all(x, "[\t]", " "), "[\n]", " ")
  return(x)
}
```
1.2 Ejemplo
```R
query <- 
"
SELECT *
TRON2000.A2000030
WHERE APELLIDOS = 'CASTILLO';
"

SQL_format(x = query)
```
1.3 Resultado
```
[1] "SELECT * FROM TRON2000.A2000030 WHERE APELLIDOS = 'CASTILLO';"
```
