source("Code/dataCleaning/readCleanGLENDA.R")
library(tidyverse)
library(gt)

df <- readCleanGLENDA("Data/Raw/GLENDA/GLENDA.csv") 
  filter(grepl("suspended", ANALYTE, ignore.case=T)) %>%
  select(MEDIUM, ANALYTE, VALUE, METHOD) 

df %>%
  distinct(ANALYTE, FRACTION, METHOD, UNITS)
usgs <- read_csv("public_srsnames_July_2023.csv")  
WQXnicks<- read_csv("Data/Meta/Characteristic Alias.csv") 
wqx <- read_csv("Data/Meta/Characteristic.csv") 


wqx %>% 
  filter(grepl("phosphorus", Name, ignore.case = T)) %>% select(Name) %>% print(n = 33)
  filter(grepl("ortho", Name, ignore.case = T))  %>% select(Name)
  filter(UniqueIdentifier == 4017)  %>% 
  select(5:7)



wqx %>% 
  filter(`UniqueIdentifier`== 1789) %>%
  select(SampleFractionRequired,
   AnalyticalMethodRequired, MethodSpeciationRequired)

wqx <- read_csv("Data/Meta/All Domain Values.csv") %>%
  filter(Domain == "Characteristic(CharacteristicName)")



df %>%
  left_join(WQXnames, by = c("ANALYTE" = "Name")) %>% 
  select(ANALYTE, FRACTION, METHOD, SampleFractionRequired, AnalyticalMethodRequired, MethodSpeciationRequired) %>%
  mutate(FRACTION = case_when(
    FRACTION == "Total/Bulk" ~ "tot",
    FRACTION == "Residue" ~ "part",
    FRACTION == "Filtrate" ~ "diss",
    # The other choices are NA or not applicable
    .default = ""
  ))

df2 <- read_csv("Data/Meta/ResultSampleFraction.csv")

