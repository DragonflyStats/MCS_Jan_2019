library(dplyr)
library(magrittr)
library(brms)
library(readr)

sbp <- read_csv("https://raw.githubusercontent.com/DragonflyStats/MCS_Summer_2019/master/MeasurementComp/sbp.csv")

head(sbp)
Fit2 <- brm( y ~ meth-1 + (meth-1| item), data =sbp, autocor = cor_ar(formula = ~repl|meth,p=1,cov=TRUE), iter=2000,control =list(adapt_delta=0.999))
summary(Fit2)
VarCorr(Fit2)

residuals(Fit2,re_formula =  ~repl|meth)


Resids <- residuals(Fit2,re_formula =  ~repl|meth) %>% as.data.frame()

> resids <- data.frame(sbp,Resids) %>% select(item,repl,meth,Estimate) %>% spread(meth,Estimate) %>% select(J,R,S) 
> cov(resids)
