### -- Introduction and refreshers for R
### -- https://github.com/aurielfournier/Midwest_FW_2020

#######################################
### -- Necessary packages
#######################################

library(dplyr)
library(tidyr)
library(ggplot2)
# if these do not load, run the matching one of these below
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("ggplot2")


###################
### -- Loading In The Data
####################

# set working directory!!

# discuss eBird data

ebird <- read.csv("eBird_workshop.csv") # the same line

# Explain how to leave comments 

View(ebird)

#########################
### -- Filtering
#########################

ebird %>%
        filter(state=='AK',
               year==2008)

# Explain What Pipes are %>% 

# explain assignment operators
a = 100
a <- 100

# filter is for rows
# select is for columns

## With pipes
ebird %>%
  filter(state=='AK',
         year==2008) %>% 
        select(state, samplesize, presence)

## Without pipes

ebird_filter <- filter(ebird, state=="AK",year==2008)

select(ebird_filter, state, samplesize, presence)


# the "|" means 'or' in R
ebird %>%
      filter(state=="AK"|state=="AZ") %>%
      # comments here 
      distinct(state)

# the "&" means "and" in R
ebird %>%
          filter(year>=2014&year<=2018) %>% 
          distinct(year)

#########################
### -- Match %in%   
#########################

a_states <- c("AZ","AK","AL","AR")

ebird %>%
          filter(state %in% a_states) %>% 
          distinct(state)


#########################
### -- GROUPING
#########################

ebird %>%
  group_by(state) %>%
  summarize(mean = mean(samplesize),
            median = median(samplesize))


ebird %>% 
          group_by(state, year) %>%
          summarize(mean=mean(samplesize))

#########################################
### -- CHALLENGE
#########################################

# What is the median samplesize for 
# Arizona, Alaska, Arkansas and Alabama after 2014?

# AZ AK AR AL 

ebird %>% 
  filter(year>2014, state %in% a_states)
  filter(state=="AK"|state=="AR"|state=="AZ"|state=="AL") %>%
  #group_by(state) %>% 
  summarize(median = median(samplesize))










new_data <- ebird %>% 
  filter(state %in% a_states,
         year > 2014) %>% 
  group_by(state) %>%
  summarise(medianS = median(samplesize))


#note to self talk about Kiwi vs Us spelling


#########################
## MUTATE
#########################

mebird <- ebird %>%  
  mutate(a_state = ifelse(state %in% a_states, 1, 0),
         state_year = paste0(state,"_",year)) 

mebird %>%
  tail()
  
########################
## Separate
########################

mebird %>% 
  separate(state_year, 
           sep="_", 
           into=c("state",
                  "year"),
           remove=FALSE) %>%
  head()

# or

mebird %>% 
  separate(year, sep=c(2,3), 
           into=c("century","middle","endpart"),
           remove=FALSE) %>%
  head()

########################
## Joins
########################

cool_birds <- c("Sora","Virginia Rail","Yellow Rail")

ebird1 <- ebird %>% 
            filter(state %in% a_states,
                   species %in% cool_birds) %>%
            select(species, state, year, samplesize) %>%
            filter(year >= 2014)

# point out that you can use multiple filter statements if you want, or you can put them all in one statement, same result. 

years_to_keep <- c(2008:2012, 2015)

ebird2 <- ebird %>%
            filter(state %in% a_states,
                  species %in% cool_birds) %>%
            select(species, state, year, presence) %>%
            filter(year %in% years_to_keep)

unique(ebird1$year)
unique(ebird2$year)

# 
full_join(ebird1, ebird2, by=c("year","species","state")) %>% distinct(year)

full_join(ebird1, ebird2, by=c("year","species","state")) %>% head()

# 

right_join(ebird1, ebird2, by=c("year","species","state")) %>% distinct(year)

right_join(ebird1, ebird2, by=c("year","species","state")) %>% head()

# 

left_join(ebird1, ebird2, by=c("year","species","state")) %>% distinct(year)

left_join(ebird1, ebird2, by=c("year","species","state")) %>% head()

# 

inner_join(ebird1, ebird2, by=c("year","species","state")) %>% distinct(year)

inner_join(ebird1, ebird2, by=c("year","species","state")) %>% head()


#####################################
## CHALLENGE
#####################################

## create two datasets, one with data only from Illinois, with the state, species, presence and year columns. 
# the other with data only from 2008 with the year, samplesize and state columns. 
# Join them together using a full join, a right join and an inner join, joining by both year and state, 
# compare the outputs from the three join types










il <- ebird %>%
        filter(state=="IL") %>%
        select(state, species, presence, year)

oh8 <- ebird %>%
        filter(year==2008) %>%
        select(year, state, samplesize)

full_join(il, oh8, by=c("year","state"))
right_join(il, oh8, by=c("year","state"))
inner_join(il, oh8, by=c("year","state"))


## depending on time skip second challenge


########################################
## Challenge
##########################################

# Calculate the mean presence in 2010
# of 2 randomly selected a_states 
# Hint: Use the dplyr functions sample_n(), 
# they have similar syntax to other dplyr functions.
# ?sample_n for help

ebird %>%
  filter(year==2010,
         state %in% a_states) %>%
  group_by(state) %>%
  sample_n(2) %>%
  summarize(mean=mean(presence))
