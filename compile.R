library(tidyverse)
library(janitor)

#define data path
data_path <- "Selenium-Downloads/"

#create list of all csv files
files <- dir(path = data_path, pattern = "*.csv")

#read all files and append file name
raw_ssm <- data.frame(filename = files) %>% #create data frame holding file names
  mutate(file_contents = map(filename, ~read_csv(file.path(data_path, .), show_col_types = FALSE))) %>% #read files into a new data column as a data frame
  unnest(cols = c(file_contents)) %>% #unnest
  mutate(filename = str_replace(filename, "Degree_Transfer", "DegreeTransfer")) %>%  #remove underscore
  mutate(filename = str_extract(filename, pattern = "(?<=_)(.*?)(?=_)")) %>%  #read everything between the two underscore
  rename(journey_status = filename) %>% 
  clean_names()

#save file
save(raw_ssm, file = "raw_ssm.RData")
