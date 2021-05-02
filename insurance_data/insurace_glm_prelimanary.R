#### Preliminary regession analysis for insurance agencies in GA.

# Read in merged insurance table  as .csv file and convert to data.frame object

all <- read.csv("all.csv")

View(all) # Look at data.frame?

####

pop <- all$totpop19 # grab vector of population census size in each county in 2019.

# grab vector of accident frequency in each county in GA from 2017 - Aug 2019.
accidents <- all$accident_count 

# Explore the shape of the distribution using a data.frame.
hist(all$all_companies) # Frequency of insurage agencies in each county.
hist(all$all_companies/all$totpop19) # Insurances agencies per 10000 people.
hist(all$accident_count/all$totpop19) # Accidents per 10000 people.
hist(log(all$all_companies/all$totpop19)) # log agency rate.
hist(log(all$accident_count/all$totpop19)) # log accident rate.

# make named vectors for rate data.
log_c_rate <- log(all$all_companies/all$totpop19)
log_a_rate <- log(all$accident_count/all$totpop19)

plot(all$accident_count ~ log_a_rate)
plot(all$all_companies ~ all$accident_count)

########################## 
# variance to mean ratio #
##########################

mean(all$all_companies) / var(all$all_companies)


# Fit quasi-Poisson model
fit1 <- glm(all_companies ~ accident_count + log(offset(totpop19)), 
            data = all, family = quasipoisson())


summary(fit1)
# 

# Call:
# glm(formula = all_companies ~ accident_count + log(offset(totpop19)), 
#     family = quasipoisson(), data = all)

# Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-6.6746  -1.5811  -0.2654   0.7716   4.5856  

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
(Intercept)           -2.607e+00  4.736e-01  -5.505 1.48e-07 ***
accident_count         2.147e-05  8.473e-06   2.534   0.0123 *  
log(offset(totpop19))  4.543e-01  4.370e-02  10.397  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for quasipoisson family taken to be 3.85968)

    Null deviance: 1402.11  on 158  degrees of freedom
Residual deviance:  637.74  on 156  degrees of freedom
AIC: NA

Number of Fisher Scoring iterations: 5






