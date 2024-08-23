library(sidrar)
#library(DT)
library(tidyverse)


# https://sidra.ibge.gov.br/tabela/5457
#x <- get_sidra(x = 5457)

regiao <- c(1,5)
tabela_2018 <- data.frame()

for(i in regiao){
  x <- get_sidra(x = 5457, # código da tabela no Sidra
                 geo = 'City', # nível de detalhe espacial da informação
                 geo.filter = list("Region" = i), #região
                 variable = 8331, # variável de interesse
                 period = as.character(2018) # ano dos dados
  )
  tabela_2018 <- rbind(tabela_2018,x)
}

#x <- datatable(tabela_2018) - 

#View(tabela_2018)
attach(tabela_2018)

tabela_2018 <- tabela_2018 |> 
  select(Valor, `Município (Código)`, Município, `Produto das lavouras temporárias e permanentes (Código)`,
         `Produto das lavouras temporárias e permanentes`)

tabela_soja_arroz_2018 <- tabela_2018 |> 
  filter(`Produto das lavouras temporárias e permanentes` %in% c("Soja (em grão)", 
                                                                 "Arroz (em casca)")) |> 
  separate(Município, into = c("Municipio", "Estado"), sep = " - ") |> 
  drop_na()

View(tabela_soja_arroz_2018)

openxlsx::write.xlsx(tabela_soja_arroz_2018, file = "tabela_soja_arroz_2018.xlsx")







