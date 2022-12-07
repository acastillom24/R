# Info from:
# https://www.listendata.com/2019/06/create-infographics-with-r.html?m=1

# Instalacion de paquetes -------------------------------------------------
# install.packages("devtools")
# install.packages("waffle")
# install.packages("remotes")

=======
# https://www.listendata.com/2019/06/create-infographics-with-r.html?m=1

# Instalación de paquetes -------------------------------------------------
install.packages("devtools")
install.packages("waffle")
install.packages("remotes")


# Carga de bibliotecas ---------------------------------------------------- 
library(dplyr)
library(ggplot2)



# Paquete waffle ----------------------------------------------------------
library(waffle)
waffle(
  parts = c('Yes=70%' = 70, 'No=30%' = 30),
  rows = 10, 
  colors = c("#FD6F6F", "#93FB98"),
  title = 'Responses', legend_pos="bottom"
  )

## Uso de iconos
library(extrafont)
remotes::install_version("Rttf2pt1", version = "1.3.8")
extrafont::font_import(paths = "D:\\Proyectos\\GitHub\\R\\Infographics with R\\", 
                       pattern = "FontAwesome", 
                       prompt =  FALSE)
extrafont::loadfonts(device = "win")
extrafont::fonts()

extrafont::fonttable() %>% 
  dplyr::as_tibble() %>% 
  dplyr::filter(grepl("Awesom", FamilyName)) %>% 
  select(FamilyName, FontName, fontfile)

waffle(
  parts = c('Poor=10' = 10, 'Average=18' = 18, 'Excellent=7' = 7), 
  rows = 5, 
  colors = c("#FD6F6F", "#93FB98", "#D5D9DD"),
  use_glyph = "female", 
  glyph_size = 12,
  title = 'Girls Performance', 
  legend_pos="bottom"
)

font_add(family = "FontAwesome", 
         regular = "D:\\Proyectos\\GitHub\\R\\Infographics with R\\fontawesome-webfont.ttf")

waffle(c(50, 30, 15, 5), rows = 5, use_glyph = "music", glyph_size = 6)

fonts()[grep("Awesome", fonts())]
showtext_auto()

waffle(c(5,12,18), rows = 5, use_glyph = "subway", glyph_size = 10, 
       title = "Subways!", legend_pos="right")

install.packages("emojifont")

library(emojifont)
library(extrafont)
extrafont::font_import (path="D:\\Proyectos\\GitHub\\R\\Infographics with R\\", pattern = "awesome", prompt = FALSE)
loadfonts(device = "win")
# check to see if it works:
fonts()[grep("Awesome", fonts())]
#returns fontawesome


waffle(c(50, 30, 15, 5), rows = 5, use_glyph = "music", glyph_size = 6)
fonts()[grep("Awesome", fonts())]

waffle(
  parts = c('Poor Quality=6' = 6, 'Top Quality=15' = 15), 
  rows = 3, 
  colors = c("#FD6F6F", "#93FB98"),
  use_glyph = "apple", 
  glyph_size = 12,
  
  #glyph_font = "FontAwesome5Brands-Regular",
  #glyph_font_family = "Font Awesome 5 Brands Regular",
  title = 'Apples',
  legend_pos = "bottom"
) + theme(plot.title = element_text(hjust = 0.5))

waffle(c(50, 30, 15, 5), rows = 5, use_glyph = "child", glyph_size = 6, title = "Look I made an infographic using R!")

library(showtext)
font_add(family = "FontAwesome5Free-Solid", regular = "D:\\Proyectos\\GitHub\\R\\Infographics with R\\fa-solid-900.ttf")
font_add(family = "FontAwesome5Free-Regular", regular = "D:\\Proyectos\\GitHub\\R\\Infographics with R\\fa-regular-400.ttf")
font_add(family = "FontAwesome5Brands-Regular", regular = "D:\\Proyectos\\GitHub\\R\\Infographics with R\\fa-brands-400.ttf")
showtext_auto()

waffle(c(50, 30, 15, 5), rows = 5, use_glyph = "music", glyph_size = 6)

waffle::fa_grep("female")

devtools::install_github("JohnCoene/echarts4r.assets")
