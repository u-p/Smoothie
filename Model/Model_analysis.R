

library(tidyverse)


# Activation:
act.cond1 <- read_csv('R-ACT-R/output-5k_v2/cond-1/act-out-1.csv') %>% 
  na.omit()

# act.cond1 %>% 
#   filter(stepNo == 4) %>% 
#   group_by(subStep) %>% 
#   summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
#   arrange(time)

act.cond1 %>% 
  # filter(stepNo == 4) %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

# Generate fixations
# act.cond1 <- act.cond1 %>%
#   mutate(knopf.fix = case_when(
#     knopf.act > flasche.act ~ 1,
#     knopf.act < flasche.act ~ 0,
#     knopf.act == flasche.act ~ sample(c(0, 1), 1)
#   )) %>%
#   ungroup()


# 'map_int()' is needed because otherwise sample() isn't called 
# for each row, but only once since ifelse() evaluates for all rows
act.cond1 <- act.cond1 %>%
  mutate(knopf.fix = map_int(seq_len(n()), ~ {
    if (knopf.act[.x] > flasche.act[.x]) {
      return(1)
    } else if (knopf.act[.x] < flasche.act[.x]) {
      return(0)
    } else {
      return(sample(c(0, 1), 1))
    }
  })) %>% 
  mutate(flasche.fix = 1- knopf.fix)

# Sanity check
act.cond1 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


act.cond1 <- act.cond1 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.fix.prob = mean(knopf.fix), 
            f.fix.prob = mean(flasche.fix)) %>% 
  arrange(time) %>% 
  print(n = Inf)








act.cond2 <- read_csv('R-ACT-R/output-5k_v2/cond-2/act-out-1.csv')

act.cond2 %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)

act.cond2 %>% 
  # filter(stepNo == 4) %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)


# act.cond3 <- read_csv('R-ACT-R/output-5k_NEW/cond-3/act-out-1.csv')
# act.cond3 <- read_csv('R-ACT-R/output-5k_OLD/cond-3/act-out-1.csv')
act.cond3 <- read_csv('R-ACT-R/output-5k_v2/cond-3/act-out-1.csv')

# df.sum <- act.cond3 %>% 
act.cond3 %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time)


act.cond3 %>% 
  # filter(stepNo == 4) %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)



# Use position=position_dodge()
ggplot(data=df.sum, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity", position=position_dodge())





plot(density(act.cond3$flasche.act, na.rm = T))

summary(act.cond3$flasche.act, na.rm = T)

act.cond2 %>% 
  filter(flasche.act > 10) %>% 
  count()

act.cond3 %>% 
  filter(knopf.act > 1)


# Retrievals
ret.cond1 <- read_csv('R-ACT-R/output/cond-1/retrievals-1.csv')

ret.cond1 %>% 
  group_by(p.match.possPro) %>% 
  summarise(count = n())

ret.cond2 <- read_csv('R-ACT-R/output/cond-2/retrievals-1.csv')

ret.cond2 %>% 
  group_by(p.match.possPro) %>% 
  summarise(count = n())

ret.cond3 <- read_csv('R-ACT-R/output/cond-3/retrievals-1.csv')

ret.cond3 %>% 
  group_by(p.match.det) %>% 
  summarise(count = n())




# ****************


# *** NEXT ==> 
# . plot activations at subsets across the two sets of 10k simulations (old and new)
# 
# - In cond 1 why is there an activation boost to Knopf at 
#   RetLat  895. 0.559  0.433 
# - In cond 2 
#   RetLat  894. 0.470  0.463 
# 




read_delim('R-ACT-R/output-10k/cond-1/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)

read_delim('R-ACT-R/output-10k/cond-2/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)

read_delim('R-ACT-R/output-10k/cond-3/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4) %>% 
  group_by(subStep) %>% 
  summarise(time = mean(time), k.act = mean(knopf.act), f.act = mean(flasche.act)) %>% 
  arrange(time)



read_delim('R-ACT-R/output-10k/cond-3/act-out-1.txt', delim = ' ') %>% 
  group_by(simNo, stepNo) %>%
  mutate(subStep = row_number()) %>% 
  filter(stepNo == 4)
  



act.cond3 %>% 
  filter(stepNo == 4)

act.cond1 %>% 
  filter(stepNo == 5)





