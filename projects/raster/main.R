# Carga de las bibliotecas
library(raster)
library(GADMTools)

# Crear un objeto RasterLayer
mat <- matrix(1:36, 6 , 6)

base <- raster(mat)

# Crear un objeto RasterStack
arr <- array(data = 1:6**3, dim = c(6, 6, 3))

multi <- brick(arr)

# Agregar o quitar una capa a un objeto
addLayer()
dropLayer()

# Crear un objeto raster desde cero
(base <- raster(ncol = 9,
                 nrow = 9,
                 xmx = -70,
                 xmn = -71,
                 ymx = -32,
                 ymn = -33))

values(base) <- as.integer(runif(ncell(base),
                                 min = 1,
                                 max = 6))

# Listar slots (ranuras) de un objeto
slotNames(base)

# Revisar el contenido de un slot
slot(base, name = 'extent')

# Propiedades geométricas de los rasters
dim(base); ncol(base); nrow(base)
xres(base); yres(base); res(base); ncell(base); extent(base)

# Estadísticas generales
cellStats(base, stat = min)
cellStats(base, stat = max)
cellStats(base, stat = 'mean')
cellStats(base, stat = 'sd')
cellStats(base, stat = 'sum')

unique(base)
freq(base, digits = 0)

# Acceder y modificar los nombres de las variables
names(base) <- 'mi_variable'

# Número de celdas
xFromCell(base, 1) # Coordenada x de celda 1
yFromCell(base, 1:3) # Vector coordenada de celda 1 a 3
cellFromXY(base, c(-70.4, -32.8)) # Número de celda
validCell(base, 0) # id fuera del vector
validCell(base, 1)

# Número de columnas
xFromCol(base, 1)
yFromRow(base, 1)
