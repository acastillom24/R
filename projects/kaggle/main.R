library(dplyr)

dataGSS <- 
  read.csv(file = "Global_Superstore2.csv")


dim(dataGSS)


dataGSS$Order.ID %>% unique() %>% length()

freqCompra <- 
  dataGSS %>% 
  select(Customer.ID, Customer.Name, Order.ID) %>% 
  unique() %>% 
  group_by(Customer.ID, Customer.Name) %>% 
  summarise(n = n()) %>% 
  arrange(-n)

dim(freqCompra)

sum(freqCompra$n)

library(ggplot2)

freqCompra %>% 
  ggplot(mapping = aes(y = n)) +
  geom_boxplot()

?as.Date.character()


library(skimr)
skim(dataGSS)
