install.packages(tm)
library(tm)
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)

# =============
files <- list.files(path = "data/")
df <- data.frame()

for (i in files){
  df_temp <- read.csv(file=paste('data/', i, sep = ""), sep=';', dec=',')
  df <- rbind(df, df_temp)
}
rm(df_temp, i, files)

# =============

df$taster_name <- stri_trans_general(df$taster_name, "cyrillic-latin")

df <- df[!duplicated(df),]
row.names(df) <- NULL

print(paste('Number of unique tasters:', length(unique(df$taster_name))))


# =============

df$year <- str_replace(df$title, df$winery, '')
df$year <- str_replace_all(df$year, "[[:punct:]]", "")
df$year <- str_replace_all(df$year, "[+]+", "")

designation <- str_replace_all(df$designation, "[[:punct:]]", "")
designation <- str_replace_all(designation, "[+]+", "")

for (i in 1:length(df$title)){
  if (!is.na(designation[i]) & designation[i]!=''){
    df$year[i] <- str_replace(df$year[i], designation[i], '')
  }
}
df$year <- str_extract(df$year, "[0-9]{4}")

df$year <- as.numeric(df$year)

# =============

colSums(is.na(df))

sort(unique(df$year))



