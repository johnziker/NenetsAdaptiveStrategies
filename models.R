# R version 4.2.2 (2022-10-31 ucrt)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 19043)
# 
# other attached packages:
#   [1] class_7.3-20        bayesplot_1.9.0     brms_2.18.0         Rcpp_1.0.9          rstan_2.26.15      
# [7] StanHeaders_2.26.15 gdata_2.18.0.1      tibble_3.1.8        viridis_0.6.2       viridisLite_0.4.1   ggplot2_3.3.6      
# [13] dplyr_1.0.10 

############# 
library(rstan)
library(brms)
library(bayesplot)

# Variable effect of household
bfit1 <- brm(bi_migb ~  (1|hid), data=data, family=negbinomial("log"))   

posterior1 <- as.array(bfit1)
dimnames(posterior1)
color_scheme_set("red")
mcmc_intervals(posterior1, pars = c(  
  "sd_hid__Intercept",
  "r_hid[3,Intercept]",    
  "r_hid[28,Intercept]",    
  "r_hid[4,Intercept]",    
  "r_hid[21,Intercept]",    
  "r_hid[22,Intercept]",    
  "r_hid[26,Intercept]",   
  "r_hid[25,Intercept]",    
  "r_hid[23,Intercept]",   
  "r_hid[24,Intercept]",    
  "r_hid[27,Intercept]",    
  "r_hid[9,Intercept]",   
  "r_hid[18,Intercept]",    
  "r_hid[19,Intercept]",    
  "r_hid[20,Intercept]",    
  "r_hid[13,Intercept]",    
  "r_hid[14,Intercept]",   
  "r_hid[5,Intercept]",     
  "r_hid[6,Intercept]",     
  "r_hid[7,Intercept]",     
  "r_hid[8,Intercept]",     
  "r_hid[1,Intercept]",    
  "r_hid[10,Intercept]",    
  "r_hid[11,Intercept]",    
  "r_hid[12,Intercept]",    
  "r_hid[2,Intercept]",     
  "r_hid[15,Intercept]",   
  "r_hid[16,Intercept]",    
  "r_hid[17,Intercept]"))

# fixed effects of year and hhsize, random hh
bfit2 <- brm(bi_migb ~ year + hhsize + (1|hid), data=data, family=negbinomial("log"))   

# had 1 divergent transition after warmup, around 200

mcmc_plot(bfit2, type ="trace")

posterior2 <- as.array(bfit2)
dimnames(posterior2)
color_scheme_set("red")
mcmc_intervals(posterior2, pars = c(
  "b_year",
  "b_hhsize",
  "sd_hid__Intercept",
  "r_hid[3,Intercept]",    
  "r_hid[28,Intercept]",    
  "r_hid[4,Intercept]",    
  "r_hid[21,Intercept]",    
  "r_hid[22,Intercept]",    
  "r_hid[26,Intercept]",   
  "r_hid[25,Intercept]",    
  "r_hid[23,Intercept]",   
  "r_hid[24,Intercept]",    
  "r_hid[27,Intercept]",    
  "r_hid[9,Intercept]",   
  "r_hid[18,Intercept]",    
  "r_hid[19,Intercept]",    
  "r_hid[20,Intercept]",    
  "r_hid[13,Intercept]",    
  "r_hid[14,Intercept]",   
  "r_hid[5,Intercept]",     
  "r_hid[6,Intercept]",     
  "r_hid[7,Intercept]",     
  "r_hid[8,Intercept]",     
  "r_hid[1,Intercept]",    
  "r_hid[10,Intercept]",    
  "r_hid[11,Intercept]",    
  "r_hid[12,Intercept]",    
  "r_hid[2,Intercept]",     
  "r_hid[15,Intercept]",   
  "r_hid[16,Intercept]",    
  "r_hid[17,Intercept]"))


# fixed effects of year, adults, z_herdsize, variable effect of hid
bfit3 <- brm(bi_migb ~ year + hhsize + z_herdsize+(1|hid), data=data, family=negbinomial("log"))   

posterior3 <- as.array(bfit3)
dimnames(posterior3)
color_scheme_set("red")
mcmc_intervals(posterior3, pars = c(
  "b_year",
  "b_hhsize",
  "b_z_herdsize",
  "sd_hid__Intercept",
  "r_hid[3,Intercept]",    
  "r_hid[28,Intercept]",    
  "r_hid[4,Intercept]",    
  "r_hid[21,Intercept]",    
  "r_hid[22,Intercept]",    
  "r_hid[26,Intercept]",   
  "r_hid[25,Intercept]",    
  "r_hid[23,Intercept]",   
  "r_hid[24,Intercept]",    
  "r_hid[27,Intercept]",    
  "r_hid[9,Intercept]",   
  "r_hid[18,Intercept]",    
  "r_hid[19,Intercept]",    
  "r_hid[20,Intercept]",    
  "r_hid[13,Intercept]",    
  "r_hid[14,Intercept]",   
  "r_hid[5,Intercept]",     
  "r_hid[6,Intercept]",     
  "r_hid[7,Intercept]",     
  "r_hid[8,Intercept]",     
  "r_hid[1,Intercept]",    
  "r_hid[10,Intercept]",    
  "r_hid[11,Intercept]",    
  "r_hid[12,Intercept]",    
  "r_hid[2,Intercept]",     
  "r_hid[15,Intercept]",   
  "r_hid[16,Intercept]",    
  "r_hid[17,Intercept]"))


#Fixed effect of year, hhsize, herdsize and reason, variable effect of hid
bfit4 <- brm(bi_migb ~ year + hhsize + z_herdsize+ reason +(1|hid), data=data, family=negbinomial("log"))   

posterior4 <- as.array(bfit4)
dimnames(posterior4)
color_scheme_set("red")
mcmc_intervals(posterior4, pars = c(  
  "b_year",                
  "b_hhsize",              
  "b_z_herdsize",          
  "b_reasonindustry",     
  "b_reasonpasture",       
  "b_reasonsocial",        
  "b_reasonweak_herd",     
  "b_reasonwild_reindeer", 
  "sd_hid__Intercept"))

#Fixed effects of year, household size, winter sum temp, summer sum temp, variable effect of household
bfit5 <- brm(bi_migb ~ year + hhsize + z_herdsize + z_w_sumtemp + z_s_sumtemp + (1|hid), data=data, family=negbinomial("log"))   

posterior5 <- as.array(bfit5)
dimnames(posterior5)
color_scheme_set("red")
mcmc_intervals(posterior5, pars = c(
  "b_year",              
  "b_hhsize",            
  "b_z_herdsize",        
  "b_z_w_sumtemp",       
  "b_z_s_sumtemp",      
  "sd_hid__Intercept"))

#Fixed effects of year, adults, z_herdsize, winter high temp days, summer high temp days; variable effect of household
bfit6 <- brm(bi_migb ~ year + hhsize + z_herdsize+ z_w5c + z_s_20Cdays + (1|hid), 
             data=data, family=negbinomial("log"))   

posterior6 <- as.array(bfit6)
dimnames(posterior6)
color_scheme_set("red")
mcmc_intervals(posterior6, pars = c(
  "b_year",              
  "b_hhsize",            
  "b_z_herdsize",        
  "b_z_w5c",             
  "b_z_s_20Cdays",
  "sd_hid__Intercept"))


#Fixed effects of year, adults, z_herdsize, winter high temp days, summer sum temp; variable effect of household
bfit7 <- brm(bi_migb ~ year + hhsize + z_herdsize+ z_w5c + z_s_sumtemp + (1|hid), 
             data=data, family=negbinomial("log"))   
#resulted in divergent transitions

# posterior7 <- as.array(bfit7)
# dimnames(posterior7)
# color_scheme_set("red")
# mcmc_intervals(posterior7, pars = c(
#   "b_year",              
#   "b_hhsize",            
#   "b_z_herdsize",        
#   "b_z_w5c",             
#   "b_z_s_20Cdays"))


#Fixed effects of year, adults, z_herdsize, winter high temp days, summer high temp days, winter rain on snow; Variable effect of household
bfit8 <- brm(bi_migb ~ year + hhsize + z_herdsize+ z_w5c + z_s_20Cdays + z_w_ros + (1|hid), 
             data=data, family=negbinomial("log"))   

posterior8 <- as.array(bfit8)
dimnames(posterior8)
color_scheme_set("red")
mcmc_intervals(posterior8, pars = c(
  "b_year",              
  "b_hhsize",            
  "b_z_herdsize",        
  "b_z_w5c",             
  "b_z_s_20Cdays",      
  "b_z_w_ros",           
  "sd_hid__Intercept"))


#Fixed effects of year, adults, z_herdsize, winter temperature sum, summer warm days, winter rain on snow; Variable effect of household
bfit9 <- brm(bi_migb ~ year + hhsize + z_herdsize+ z_w_sumtemp + z_s_20Cdays + z_w_ros + (1|hid), 
             data=data, family=negbinomial("log"))   

posterior9 <- as.array(bfit9)
dimnames(posterior9)
color_scheme_set("red")
mcmc_intervals(posterior9, pars = c(
  "b_year",              
  "b_hhsize",            
  "b_z_herdsize",        
  "b_z_w_sumtemp",       
  "b_z_s_20Cdays",      
  "b_z_w_ros",           
  "sd_hid__Intercept"))
