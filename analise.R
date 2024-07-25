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


agrupado_por_substancia2 <- banco |> 
  group_by(substancia) |> 
  summarize(uf = n()) |> 
  arrange(desc(uf))


View(agrupado_por_substa ncia2)



# sub_por_estado <- banco |> 
#   group_by(uf, ano, semestre, substancia, dif_analise_coleta) |> 
#   summarize(count_substancias = n_distinct(substancia), .groups = 'drop')


sub_por_estado <- banco |>
  group_by(uf, ano, semestre, substancia) |>
  summarize(media_diferenca_dias = round(mean(dif_analise_coleta, na.rm = TRUE),2), .groups = 'drop')


View(sub_por_estado)

dados_sub_estado_2018 <- sub_por_estado |> 
  filter(ano, uf=='RS')
 
top_substancias <- dados_sub_estado_2018 |> 
  count(substancia) |> 
  arrange(desc(n)) |> 
  slice_head(n = 20)




dados_top20 <- dados_sub_estado_2018 |> 
  filter(substancia %in% top_substancias$substancia)


ggplot(dados_top20, aes(x = substancia, y = media_diferenca_dias, fill = uf)) +
  geom_boxplot() +
  labs(title = "Box Plot das Médias de Diferença de Dias por Substância e Estado (Top mais Frequentes)",
       x = "Substância",
       y = "Média da Diferença de Dias") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

##### TOP SUBSTANCIA POR ESTADO
# estados_desejados <- c("BA", "SP", "RJ")
# dados_filtrados_estados <- banco |>
#   filter(uf %in% estados_desejados)




freq_substancia_estado <- banco |>  #dados_filtados_estados
  count(uf, substancia) |> 
  arrange(uf, desc(n))


top_substancias_estado <- freq_substancia_estado |> 
  group_by(uf) |> 
  slice_head(n = 1) |> 
  ungroup()


ggplot(top_substancias_estado, aes(x = reorder(substancia, n), y = n, fill = uf)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Substâncias Mais Frequentes por Estado",
       x = "Substância",
       y = "Frequência") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

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
#  mutate(dif_coleta_analise = (data_da_analise)-(data_da_coleta))
# 
# View(banco_periodo2)


# PRIMEIRO TRIMESTRE 2018 A 2020
df_1trimestre <- banco|> 
  filter(month(data_da_analise) %in% 1:3)


sub_muni_1trimestre<-df_1trimestre |> 
  group_by(data_da_analise,municipio, substancia, dif_analise_coleta) |> 
  summarise(count = n(), .groups = 'drop')

View(sub_muni_1trimestre)


# SEGUNDO TRIMESTRE 2018 A 2020

df_2trimestre<-banco_periodo |> 
  filter(month(data_da_analise) %in% 4:6)

sub_muni_2trimestre <-df_2trimestre |> 
  group_by(data_da_analise, municipio, substancia) |> 
  summarise(count = n(), .groups = 'drop')

View(sub_muni_2trimestre)



