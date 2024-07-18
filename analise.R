library(tidyverse)
#library(readxl)
banco <- readxl::read_excel("substancias-quimicas-e-radioativas-acima-do-limite-no-brasil-2018-2020 (1).xlsx")
View(banco)

attach(banco)

banco<-data.frame(banco)

banco_mun<- banco |> 
  group_by(municipio) |> 
  summarize(substancia = list(na.omit(substancia)))  |> 
  ungroup()
  

View(banco_mun)




##---- AGRUPADO POR SUSBSTANCIA
agrupado_por_substancia <- banco |> 
  group_by(substancia) |> 
  summarize(municipio = n()) |> 
  arrange(desc(municipio))
print(agrupado_por_substancia)
