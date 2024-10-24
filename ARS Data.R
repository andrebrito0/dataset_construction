library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(readr)
library(stringr)
library(stringi)
library(tidyr)
library(openxlsx)

'%!in%' <- function(x,y)!('%in%'(x,y))

##### Auxilary Date dataframe #####

REF_week_year <- tibble(date = seq.Date(as.Date('2020-03-24'), as.Date('2022-03-03'), by = '1 day'))
REF_week_year$week_year <- paste0(week(REF_week_year$date),"_",year(REF_week_year$date))
REF_week_year <- REF_week_year %>% group_by(week_year) %>% summarise(date = last(date))

##### DATA ARS #####
data <- read_csv("data.csv") 
data <- data %>% select(all_of(colnames(data)[c(1,4:8,49:53)]))
data$data <- as.Date(data$data, format = '%d-%m-%Y')
data_confirmados <- data %>% select(data, confirmados_arsnorte, confirmados_arscentro, confirmados_arslvt, confirmados_arsalentejo, confirmados_arsalgarve)
data_obitos <- data %>% select(data, obitos_arsnorte, obitos_arscentro, obitos_arslvt, obitos_arsalentejo, obitos_arsalgarve)
colnames(data_confirmados) <- c('date', 'ARS Norte', 'ARS Centro', 'ARS LVT', 'ARS Alentejo', 'ARS Algarve')
colnames(data_obitos) <- c('date', 'ARS Norte', 'ARS Centro', 'ARS LVT', 'ARS Alentejo', 'ARS Algarve')

data_long_confirmados <- melt(data_confirmados, id = "date")
colnames(data_long_confirmados) <- c('date','ars','confirmed')
data_long_obitos <- melt(data_obitos, id = "date")
colnames(data_long_obitos) <- c('date','ars','deaths')

data_long <- left_join(data_long_confirmados, data_long_obitos)
data_long <- data_long %>% group_by(ars) %>% mutate(new_cases = confirmed - lag(confirmed) , new_deaths = deaths - lag(deaths))
data_long$new_cases[data_long$new_cases < 0] <- 0
data_long$new_deaths[data_long$new_deaths < 0] <- 0

data_long %>% ggplot(aes(x = date, y = new_cases, group = ars)) + facet_grid(ars~., scales = 'free_y') + geom_line()
data_long %>% ggplot(aes(x = date, y = new_deaths, group = ars)) + facet_grid(ars~., scales = 'free_y') + geom_line()

saveRDS(data_long, file = 'data_long_ARS.rds')


##### DATA GLOBAL #####
data <- read_csv("data.csv") 
data$data <- as.Date(data$data, format = '%d-%m-%Y')
data <- data %>% select(all_of(colnames(data)[c(1,3,13,14,15,16)]))
data <- data %>% mutate(new_cases = confirmados - lag(confirmados))
data$new_cases
data %>% ggplot(aes(x = data, y = new_cases)) + geom_line() + theme_bw()
