
Linear Mixed Effects models suffer from issues of mathematical  tractability.

### SAS
Roy demonstrated how to implement her approach using SAS. Bates has criticised some of the underlying assumptions of the estimation methods.

### nlme R package
nlme can properly implement the methodology proposed by Roy.
It can do everything needed in theory. Due to the complex model, it is susceptible to issues of tractability.


### lme4 R package
lme4 can easily incorporate crossed random effects.
lme4 can not yet model the residual covariance structure.

### FlexLambda
this was a development branch of LME4. It is no longer in active development.

### MixedModels.jl Julia package
MixedModels is created and designed by the same author of LME4 and is very similar in functionality.
It can not yet model the residual covariance structure.

### brms
This R package is for bayesian regression modelling with STAN.
brms uses the same syntax as LME4.
