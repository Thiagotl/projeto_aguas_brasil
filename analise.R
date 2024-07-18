library(tidyverse)
library(lubridate)
#library(readxl)
banco <- readxl::read_excel("substancias-quimicas-e-radioativas-acima-do-limite-no-brasil-2018-2020 (1).xlsx")
View(banco)

attach(banco)

banco<-data.frame(banco)

banco<-banco |> 
  mutate(data_da_coleta = dmy(data_da_coleta),
         data_da_analise = dmy(data_da_analise))


banco<-banco|> 
  mutate(dif_analise_coleta = data_da_analise - data_da_coleta)


#---- AGRUPADO POR MUNICIPIO----#
# banco_mun<- banco |> 
#   group_by(municipio) |> 
#   summarize(substancia = list(na.omit(substancia)), n())  |> 
#   ungroup() View(banco_mun)


#---- AGRUPADO POR SUSBSTANCIA ----#
agrupado_por_substancia <- banco |> 
  group_by(substancia) |> 
  summarize(municipio = n()) |> 
  arrange(desc(municipio))
View(agrupado_por_substancia)


#---- PERIODICIDADE ----#

banco_periodo<-banco |> 
  group_by(ano, semestre, municipio, substancia) |> 
  summarise(count=n(), .groups = 'drop')
View(banco_periodo)

attach(banco_periodo)


# 
# banco_periodo2<- banco |> 
#   mutate(data_da_coleta = dmy(data_da_coleta),
#          data_da_analise = dmy(data_da_analise))
# 
# banco_periodo2 <-banco_periodo2 |> 
#   mutate(dif_coleta_analise = (data_da_analise)-(data_da_coleta))

#View(banco_periodo)


# PRIMEIRO TRIMESTRE 2018 A 2020
df_1trimestre <- banco_periodo |> 
  filter(month(data_da_analise) %in% 1:3)


sub_muni_1trimestre<-df_1trimestre |> 
  group_by(data_da_analise,municipio, substancia, dif_coleta_analise) |> 
  summarise(count = n(), .groups = 'drop')

View(sub_muni_1trimestre)


# SEGUNDO TRIMESTRE 2018 A 2020

df_2trimestre<-banco_periodo |> 
  filter(month(data_da_analise) %in% 4:6)

sub_muni_2trimestre <-df_2trimestre |> 
  group_by(data_da_analise, municipio, substancia) |> 
  summarise(count = n(), .groups = 'drop')

View(sub_muni_2trimestre)



