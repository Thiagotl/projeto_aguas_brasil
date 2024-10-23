library(data.table)
library(tidyverse)

dt<-fread("total_sisagua_anos_2014_2022_download_14_set_2024.csv")

#print(object.size(dt), units = 'Gb')
#glimpse(dt)

#### DADOS REGIAO SUL ####

dados_sul<- dt |> 
  filter(uf == c('RS','PR','SC'))
View(dados_sul)

prop.table(table(dados_sul$consistencia))

table(dados_sul$tipo_de_resultado)


save.image(file = "sul.RData")
