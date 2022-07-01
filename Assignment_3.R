library(dplyr)
library(stringr)
library(tidytable)
library(ggplot2)

# 1.
df <- read.csv('StormEvents_details-ftp_v1.0_d1999_c20220425.csv')

# 2.
df <- df %>% select(BEGIN_DATE_TIME, END_DATE_TIME, EPISODE_ID, EVENT_ID, STATE,
                    STATE_FIPS, CZ_NAME, CZ_TYPE, CZ_FIPS, EVENT_TYPE, SOURCE,
                    BEGIN_LAT, BEGIN_LON, END_LAT, END_LON)

# 3.
df <- df[order(df$STATE),]


# 4.
df$STATE <- str_to_title(df$STATE)

# 5.
df <- df %>%
      filter(CZ_TYPE == 'C') %>%
      select(-CZ_TYPE)

# 6.
df$STATE_FIPS <- str_pad(df$STATE_FIPS, 2, side = 'left', pad = 0)
df$CZ_FIPS <- str_pad(df$CZ_FIPS, 3, side = 'left', pad = 0)
df$FIPS <- paste(df$STATE_FIPS, df$CZ_FIPS, sep="")

# 7.
df <- rename_all(df, tolower)

# 8.
data('state')
state_df = data.frame(state = state.name,
                      area = state.area,
                      region = state.region)

# 9.
state_nevents <- df %>%
                  group_by(state) %>%
                  summarise(n_events = length(unique(event_id)))

state_nevents_merged <- merge(state_nevents, state_df, by = 'state')

# 10.
ggplot(state_nevents_merged, aes(x=area, y=n_events, color=region)) +
  geom_point() + 
  xlab('Land area (square miles)') + 
  ylab('# of storm events in 1999')
  








