## Selecciona todo el código y presiona "Ctrl" + "Enter" para ejecutarlo
# si se demora un poco es porque se puso a instalar algún paquete (librería) que no tienes en tu PC
# si todo sale bien, debería aparecer el archivo PNG "gol_di_maria_copa_america" en la misma carpeta donde tienes el código

source("functions.R")

# Visualización
text_lines_color = "grey70"
fill_color = "#525252"
events_fill_color = "#00AAE4"

get_pitch(gp = ggplot(), dims = dims, margin = 0.6, pitch_col = "grey70", pitch_fill = fill_color) +
  annotate("segment", x = 13, xend = 0, y = 48, yend = 37, col = "#FFD700", linetype = 1, size = 0.8, 
           arrow = arrow(type = "closed", length = unit(0.07, "inches"))) +
  annotate("curve", x = 80, xend = 20, y = 66, yend = 53, col = "white", linetype = 2, curvature = 0.15) +
  annotate("text", x = 38, y = 67, label = "Movimiento sin balón\nde Di María", col = "white", angle = 0) +
  geom_segment(data = data %>% filter(event.type_name == "pass"),
               aes(x = pos_x_meter, y = pos_y_meter, xend = pass_end_pos_x_meter, yend = pass_end_pos_y_meter),
               alpha = 0.5, size = 0.8, col = events_fill_color) +
  geom_segment(data = data %>% filter(event.type_name == "carrera"),
               aes(x = pos_x_meter, y = pos_y_meter, xend = carrera_end_pos_x_meter, yend = carrera_end_pos_y_meter),
               alpha = 0.5, size = 1, col = events_fill_color, linetype = 3) +
  geom_point(data = data %>% filter(event.type_name %in% c("shot", "pass", "ball receipt") & lag(event.type_name) != "recover"),
             aes(x = pos_x_meter, y = pos_y_meter), size = 8,  
             pch = 21, fill = events_fill_color, stroke = 1.3, col = "white") +
  geom_point(data = data %>% filter(event.type_name %in% c("recover")),
             aes(x = pos_x_meter, y = pos_y_meter), size = 7,  
             pch = 23, fill = "#fd8d3c", stroke = 1.3, col = "white") +
  geom_text(data = data %>% filter(event.type_name %in% c("shot", "pass", "ball receipt", "recover") & (lag(event.type_name) != "recover" | is.na(lag(event.type_name)))),
            aes(x = pos_x_meter, y = pos_y_meter, label = player.number), size = 4, col = "white") +
  annotate("segment", x = 65, xend = 45, y = -5, yend = -5, col = text_lines_color, 
           arrow = arrow(type = "closed", length = unit(0.1, "inches"))) +
  annotate("text", x = 56, y = -8, label = "Dirección de juego", col = text_lines_color) +
  annotate("text", x = 45, y = 45.5, label = "Pase", col = events_fill_color, angle = -18) +
  annotate("text", x = 75, y = 45, label = "Conducción", col = events_fill_color, angle = 0) +
  annotate("text", x = 81, y = 70.5, label = "Recuperación", col = "#fd8d3c", angle = 0) +
  labs(title = "<b style='color: #FFD700'>Gol <b style='color: grey70'>de <b style='color: white'>Ángel Di María <b style='color: grey70'>para <b style='color: #00AAE4'>Argentina <b style='color: grey70'>en la final de Copa América 2021",
       subtitle = "Minuto 22 / Distancia: 18.5 metros / Valor xG = 0.1",
       caption = "Data: recopilación manual\nCreado por: LPDT + @DatoFutbol_cl\nDiseño inspirado en: @Odriozolite") +
  theme(text = element_text(colour = text_lines_color, size = 12),
        plot.title = element_markdown(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 1, vjust = 1, face= "italic"),
        plot.background = element_rect(fill = fill_color, colour = "transparent"),
        plot.margin = margin(0.5, 0.3, 0.25, 0.3, "cm"),
        legend.position = "none") +
  annotate("point", x = 3, y = c(-3, -7, -11), pch = 21, fill = events_fill_color, col = "white", size = 6) +
  annotate("text", x = 2.2, y = -3, col = "white", size = 2.5, label = "11   A. Di María", hjust = 0) +
  annotate("text", x = 2.5, y = -7, col = "white", size = 2.5, label = "7    R. de Paul", hjust = 0) +
  annotate("text", x = 2.2, y = -11, col = "white", size = 2.5, label = "19   N. Otamendi", hjust = 0)


ggsave('gol_di_maria_copa_america.png', width = 9, height = 7.5)


