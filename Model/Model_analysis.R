

library(tidyverse)

retr.cond1 <- read_delim(
  'Model/R-ACT-R/output/cond-1/retrievals-1.txt', 
  delim = ' '
  ) %>% 
  mutate(empty=NULL)

retr.cond1


act.cond1 <- read_delim('Model/R-ACT-R/output/cond-1/act-out-1.txt', delim = ' ')

act.cond1 %>% 
  filter(stepNo == 4) %>% 
  group_by(step) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)


act.cond2 <- read_delim('Model/R-ACT-R/output/cond-2/act-out-1.txt', delim = ' ')

act.cond2 %>% 
  filter(stepNo == 4) %>% 
  group_by(step) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)


act.cond3 <- read_delim('Model/R-ACT-R/output/cond-3/act-out-1.txt', delim = ' ')

act.cond3 %>% 
  filter(stepNo == 4) %>% 
  group_by(step) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)

# *** NEXT ==> 
# . plot activations at subsets across the two sets of 10k simulations (old and new)
# 
# - In cond 1 why is there an activation boost to Knopf at 
#   RetLat  895. 0.559  0.433 
# - In cond 2 
#   RetLat  894. 0.470  0.463 
# 




read_delim('Model/R-ACT-R/output-10k/cond-1/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)

read_delim('Model/R-ACT-R/output-10k/cond-2/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)

read_delim('Model/R-ACT-R/output-10k/cond-3/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)



read_delim('Model/R-ACT-R/output-10k/cond-3/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4)
  



act.cond3 %>% 
  filter(stepNo == 4)

act.cond1 %>% 
  filter(stepNo == 5)



