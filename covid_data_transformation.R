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

###### District and Municipalities References ######
District_and_Municipalities <- read_excel("District and Municipalities.xlsx")
District_and_Municipalities$match <- paste0(District_and_Municipalities$Name,'_', District_and_Municipalities$District)
District_and_Municipalities$match <- str_replace(District_and_Municipalities$match," ","_")
District_and_Municipalities$match <- str_replace(District_and_Municipalities$match,"-","_")
District_and_Municipalities$match <- stri_trans_general(District_and_Municipalities$match, "Latin-ASCII")
District_and_Municipalities$match <- tolower(District_and_Municipalities$match)

##### Part 1 #####
# Dataset from 11/11/2020 to 03/03/2022
data_concelhos_new <- read_csv("data_concelhos_new.csv")
data_concelhos_new <- data_concelhos_new %>% filter(distrito %!in% c("MADEIRA","AÇORES")) %>% select('data', 'concelho','confirmados_14','confirmados_1','incidencia','ars','distrito','area','population','population_65_69','population_70_74','population_75_79','population_80_84','population_85_mais', 'population_80_mais', 'population_75_mais', 'population_70_mais', 'population_65_mais')
data_concelhos_new$data <- as.Date(data_concelhos_new$data,"%d-%m-%Y")
colnames(data_concelhos_new) <- c('date', 'municipality','confirmed','confirmed_1','incidence','ars','district','area','population','population_65_69','population_70_74','population_75_79','population_80_84','population_85_mais', 'population_80_mais', 'population_75_mais', 'population_70_mais', 'population_65_mais')

# Create a match to join with district/municipality information
data_concelhos_new$match <- paste0(data_concelhos_new$municipality,'_', data_concelhos_new$district)
data_concelhos_new$match <- str_replace(data_concelhos_new$match," ","_")
data_concelhos_new$match <- str_replace(data_concelhos_new$match,"-","_")
data_concelhos_new$match <- stri_trans_general(data_concelhos_new$match, "Latin-ASCII")
data_concelhos_new$match <- tolower(data_concelhos_new$match)
data_concelhos_new$match[data_concelhos_new$match == "lagoa_(faro)_faro"] <- "lagoa_faro"

data_concelhos_new$dow <- wday(data_concelhos_new$date)
data_concelhos_new$week_year <- paste0(week(data_concelhos_new$date),"_",year(data_concelhos_new$date))
summary(data_concelhos_new$date)

length(which(District_and_Municipalities$match %in% data_concelhos_new$match))
which(District_and_Municipalities$match %!in% data_concelhos_new$match)

# Organizing the dataset
export <- left_join(data_concelhos_new, District_and_Municipalities) 
export <- export %>% select(-c(municipality, district, match)) %>% 
  rename(municipality = Name, district = District) %>% 
  relocate(Code, .after = date) %>% 
  relocate(REF, .after = Code) %>% 
  relocate(municipality, .after = REF) %>% 
  relocate(district, .after = municipality) %>% 
  relocate(ars, .after = district) %>% 
  relocate(week_year, .after = date)
export  

# Arranging the week date 
aux <- left_join(export, REF_week_year %>% rename(week_last_day = date))
aux$date <- aux$week_last_day

export <- aux %>% select(-c(week_last_day, confirmed_1, incidence, week_year, dow)) %>% group_by(REF) %>% arrange(REF)


# Keep summary with demographic information to join with the next dataset
df_summary <- export %>% group_by(REF) %>% summarise(ars = first(ars), 
                                              area = mean(area), 
                                              population = mean(population), 
                                              population_65_69 = mean(population_65_69), 
                                              population_70_74 = mean(population_70_74), 
                                              population_75_79 = mean(population_75_79), 
                                              population_80_84 = mean(population_80_84), 
                                              population_85_mais = mean(population_85_mais), 
                                              population_80_mais = mean(population_80_mais), 
                                              population_75_mais = mean(population_75_mais), 
                                              population_70_mais = mean(population_70_mais), 
                                              population_65_mais = mean(population_65_mais))

export <- export %>% group_by(REF)

saveRDS(export, "data_covid_muni_2020_11_17.rds")

###### District and Municipalities References ######
District_and_Municipalities <- read_excel("District and Municipalities.xlsx")
District_and_Municipalities$match <- paste0(District_and_Municipalities$Name)
District_and_Municipalities$match <- str_replace(District_and_Municipalities$match," ","_")
District_and_Municipalities$match <- str_replace(District_and_Municipalities$match,"-","_")
District_and_Municipalities$match <- stri_trans_general(District_and_Municipalities$match, "Latin-ASCII")
District_and_Municipalities$match <- tolower(District_and_Municipalities$match)

##### PART 1 #####
# Dataset from 24/03/2020 to 26/10/2020
data_concelhos <- read_csv("data_concelhos.csv")
data_concelhos$data <- as.Date(data_concelhos$data,"%d-%m-%Y")
data_concelhos <- melt(data_concelhos, id = 'data' )
colnames(data_concelhos) <- c('date','municipality','confirmed')
data_concelhos$confirmed[is.na(data_concelhos$confirmed)] <- 0

# Acumulados
data_concelhos %>% filter(municipality == 'LISBOA')

# Dealing with same name municipalities
data_concelhos <- data_concelhos %>% filter(municipality != 'LAGOA')
data_concelhos$municipality[data_concelhos$municipality == 'LAGOA (FARO)'] <- 'LAGOA'

data_concelhos %>% filter(is.na(municipality))
length(unique(data_concelhos$municipality))

# Constructing the match 
data_concelhos$match <- str_replace(data_concelhos$municipality," ","_")
data_concelhos$match <- str_replace(data_concelhos$match,"-","_")
data_concelhos$match <- stri_trans_general(data_concelhos$match, "Latin-ASCII")
data_concelhos$match <- tolower(data_concelhos$match)

# erasing from the dataset municipalities in the autonomous regions of Madeira and Açores
set_arquipelagos <- unique(data_concelhos$match)[which(unique(data_concelhos$match) %!in% District_and_Municipalities$match)]
data_concelhos <- data_concelhos %>% filter(match %!in% set_arquipelagos)
length(unique(data_concelhos$match)[which(unique(data_concelhos$match) %in% District_and_Municipalities$match)])

res <- left_join(data_concelhos, District_and_Municipalities) %>% select(-c(match, municipality))

# Organzing the dataset
res <- res %>% 
  rename(municipality = Name, district = District) %>% 
  relocate(Code, .after = date) %>% 
  relocate(REF, .after = Code) %>% 
  relocate(municipality, .after = REF) %>% 
  relocate(district, .after = municipality) 

export_2 <- left_join(res, df_summary) %>% relocate(ars, .after = district)

export_2$week_year <- paste0(week(export_2$date),"_",year(export_2$date))

aux <- left_join(export_2, REF_week_year %>% rename(week_last_day = date))
aux$date <- aux$week_last_day
export_2 <- aux %>% select(-c(week_last_day))

export_2 <- export_2 %>% group_by(REF, week_year) %>% mutate(id = dplyr::row_number()) %>% filter(id == max(id)) 

export_2 <- export_2 %>% ungroup(week_year) %>% group_by(REF) %>% select(-c(week_year)) %>% relocate(REF, .after = Code) %>% group_by(REF) %>% arrange(REF)

saveRDS(export_2, 'data_covid_muni_2020_03_24.rds')

##### COMBINED #####

export <- rbind(export_2, export) %>% group_by(REF) %>% arrange(REF)
saveRDS(export, 'data_covid_muni_all.rds')





