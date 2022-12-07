
# info from: https://www.rdocumentation.org/packages/psych/versions/2.2.9/topics/fa

install.packages("psych")
library(psych)

modelo_promax <- 
  fa(r = mat_cor, n.obs = 200, nfactors = 5, rotate = "promax", fm = "ml", cor = "poly")
fa.diagram(modelo_promax)