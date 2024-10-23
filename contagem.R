# contagem de substancias identificadas em cada estacao por planilha


library(readr)
library(tidyverse)

#contagem planilha 1
dados_1 <- read_csv("dados_estacao/planilha1_pivotresult_sisagua - planilha1_pivotresult_sisagua.csv")
View(dados_1)

cont_1<-dados_1 |> 
  count(parâmetro, sort=TRUE)
#contagem planilha 2
dados_2<-read_csv("dados_estacao/planilha2_pivotresult_sisagua - planilha2_pivotresult_sisagua.csv")
View(dados_2)

cont_2<-dados_2 |> 
  count(parâmetro, sort = TRUE)

# contagem planilha 3

dados_3<-read_csv("dados_estacao/planilha3_pivotresult_sisagua - planilha3_pivotresult_sisagua.csv")

colnames(dados_3)[5] <- "parâmetro_1"
View(dados_3)
cont_3<-dados_3 |> 
  count(parâmetro_1, sort = TRUE)

cont_3<-rename(cont_3, parâmetro = parâmetro_1)

# contagem planilha 4


dados_4<-read_csv("dados_estacao/planilha4_pivotresult_sisagua - planilha4_pivotresult_sisagua.csv")

cont_4<-dados_4 |> 
  count(parâmetro, sort=TRUE)




# contagem total

dados_combinados <- cont_1 |> 
  full_join(cont_2, by = "parâmetro", suffix = c("_cont1", "_cont2"))  |> 
  full_join(cont_3, by = "parâmetro", suffix = c("", "_cont3"))  |> 
  full_join(cont_4, by = "parâmetro", suffix = c("", "_cont4"))

View(dados_combinados)


writexl::write_xlsx(dados_combinados, "contagem_subs_ETA.xlsx")
