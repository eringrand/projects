library(rtweet)
library(tidyverse)
library(lubridate)
library(janitor)

my_tweets <- get_timeline(user = "astroeringrand", n = 400) %>%
  mutate(created_at = with_tz(created_at, tz = "America/Los_Angeles"))

my_tweets_conf <- my_tweets %>%
  filter(created_at >= "2018-01-30" & created_at <= "2018-02-05") %>%
  remove_empty_cols()
  

my_tweets_rt <- my_tweets_conf %>% 
  count(is_retweet) 

my_tweets_rt

my_tweets_conf %>%
  filter(!is_retweet, status_id != "959953175456374785") %>%
  summarise_at(vars(favorite_count, retweet_count), sum)

# At least two of those like were by Hadley Wickham himself!

my_tweets <- my_tweets_conf %>%
  filter(!is_retweet, favorite_count > 0)  %>%
  pull(status_id)

x <- map_dfr(my_tweets, ~get_favorites(user = "hadleywickham", n = 199, max_id = .x))

# x %>% 
  distinct() %>%
  filter(screen_name == "astroeringrand") %>% 
  View()
