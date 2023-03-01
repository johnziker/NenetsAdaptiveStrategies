################### DESCRIPTIVES ###############

library(ggplot2)
library(viridis)
library(tibble)
library(gdata)

##### reason_year stacked bar plot#######

reason <- ggplot(data, aes(x=year, fill = factor(reason))) +
  geom_bar(position = "fill")+
  theme(legend.title=element_blank(),
        axis.title.y = element_blank())+
  scale_fill_viridis(discrete = TRUE) 

reason

########


reason2 <- ggplot(data, aes(x=year, fill = factor(reason))) +
  geom_bar(position = "fill")+
  theme(legend.title=element_blank(),
        axis.title.y = element_blank())+
  scale_fill_viridis(discrete = TRUE)

data$hid <- as.numeric(data$hid)

hh_year <- data %>% 
  group_by(year) %>% 
  summarise(hhs = n())

#################Numeric Descriptives ###################
### Household size ################
hhsize <- data %>% 
  summarise(Min = min(hhsize),
            Median = median(hhsize),
            Max = max(hhsize),
            IQR = IQR(hhsize))  

### Herdsize
herdsize <- data %>% 
  summarise(Min = min(herdsize),
            Median = median(herdsize),
            Max = max(herdsize),
            IQR = IQR(herdsize))  

#migdistance
migdist <- data %>% 
  summarise(Min = min(migdist),
            Median = median(migdist),
            Max = max(migdist),
            IQR = IQR(migdist))  

#summer 20c days
s_20Cdays  <- data %>% 
  filter(!is.na(s_20Cdays)) %>% 
  summarise(Min = min(s_20Cdays),
            Median = median(s_20Cdays),
            Max = max(s_20Cdays),
            IQR = IQR(s_20Cdays)) 

#summer sum temp
s_sumtemp <- data %>% 
  filter(!is.na(s_sumtemp )) %>% 
  summarise(Min = min(s_sumtemp ),
            Median = median(s_sumtemp ),
            Max = max(s_sumtemp),
            IQR = IQR(s_sumtemp)) 


#winter5c crossing
w_5C <- data %>% 
  filter(!is.na(w_5C )) %>% 
  summarise(Min = min(w_5C ),
            Median = median(w_5C ),
            Max = max(w_5C),
            IQR = IQR(w_5C)) 

#winter sum temp
w_sumtemp  <- data %>% 
  filter(!is.na(w_sumtemp)) %>% 
  summarise(Min = min(w_sumtemp ),
            Median = median(w_sumtemp ),
            Max = max(w_sumtemp),
            IQR = IQR(w_sumtemp))

#winter rain on snow
w_ros <- data %>% 
  filter(!is.na(w_ros )) %>% 
  summarise(Min = min(w_ros ),
            Median = median(w_ros),
            Max = max(w_ros),
            IQR = IQR(w_ros)) 

##### add climate variables 

dflist <- rbind(hhsize,herdsize,migdist,s_20Cdays ,s_sumtemp,w_5C ,w_sumtemp, w_ros)
df <- rowid_to_column(dflist,"ID")
hhTable <- df %>% 
  mutate(ID =recode(ID, '1'='hhsize', '2'='herdsize', '3'='migdist', '4'='s_20Cdays', '5'='s_sumtemp', '6'='w_5C','7'='w_sumtemp','8'= 'w_ros'))


numeric_desc <- hhTable %>% 
  mutate(Variable =recode(ID, 'hhsize'='Adults in Household', 'herdsize'='Reindeer Herd Size', 
                          'migdist'='Migration Distance (KM)', 's_20Cdays'='Days Above 20C',
                          's_sumtemp'='Hours of >20C', 'w_5C'='Count of Winter Crossing Above -5C',
                          'w_sumtemp'='Winter Hours of >-5C', 'w_ros'='Winter Precipitation >0.2C')) %>% 
  select(Variable, Min, Median, Max, IQR)

#### Categories ####################################################


#migration behavior
migb <- data %>% 
  group_by(migb) %>% 
  summarise(count = n()) %>% 
  mutate(var="migb") %>% 
  rename(value = migb)

#reason
reason <- data %>% 
  group_by(reason) %>% 
  summarise(count = n()) %>% 
  mutate(var="reason") %>% 
  rename(value = reason)

#tactical/Strategic
tac_strat <- data %>% 
  group_by(tac_strat) %>% 
  summarise(count = n()) %>% 
  mutate(var="tac_strat") %>% 
  rename(value = tac_strat)



category_table <-combine(migb, reason, tac_strat)

cat_table <- category_table %>% select(var, value, count) %>% 
  mutate(Variable =recode(var, 'migb'='Migration Behavior', 'reason'='Reason', 
                          'tac_strat'='Tactical/Strategic')) %>% 
  mutate(value = recode(value, 'neutral'='Neutral','decrease'='Decrease',
                        'increase'='Increase','shift'='Shift','climate'='Climate',
                        'industry'='Industry', 'pasture'='Pasture', 
                        'social'='Social', 'weak_herd'='Weak Herd',
                        'wild_reindeer'='Wild Reindeer', 'strategic'='Strategic',
                        'tactical'='Tactical')) %>% 
  rename(Count=count, Value=value) %>% 
  select(Variable, Value, Count)


