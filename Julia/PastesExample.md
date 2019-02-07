A Model With Nested Random Effects
In this section we again consider a simple example, this time fitting a model with nested grouping factors for the random effects.

#### The Pastes Data
The third example from Davies (1972) is described as coming from

deliveries of a chemical paste product contained in casks where, in addition to sampling and testing errors, there are variations in quality between deliveries …As a routine, three casks selected at random from each delivery were sampled and the samples were kept for reference. …Ten of the delivery batches were sampled at random and two analytical tests carried out on each of the 30 samples.

The structure and summary of the data object are
<pre><code>
julia> describe(dat[:Pastes])
4×8 DataFrame. Omitted printing of 1 columns
│ Row │ variable │ mean    │ min  │ median │ max  │ nunique │ nmissing │
│     │ Symbol   │ Union…  │ Any  │ Union… │ Any  │ Union…  │ Nothing  │
├─────┼──────────┼─────────┼──────┼────────┼──────┼─────────┼──────────┤
│ 1   │ Y        │ 60.0533 │ 54.2 │ 59.3   │ 66.0 │         │          │
│ 2   │ H        │         │ A    │        │ J    │ 10      │          │
│ 3   │ c        │         │ a    │        │ c    │ 3       │          │
│ 4   │ G        │         │ A:a  │        │ J:c  │ 30      │          │
</code></pre>
As stated in the description in Davies (1972), there are 30 samples, three from each of the 10 delivery batches. We have labelled the levels of the sample factor with the label of the batch factor followed by a, b or c to distinguish the three samples taken from that batch.
<pre><code>
julia> freqtable(dat[:Pastes][:H], dat[:Pastes][:G])
10×30 Named Array{Int64,2}
Dim1 ╲ Dim2 │ A:a  A:b  A:c  B:a  B:b  B:c  …  I:a  I:b  I:c  J:a  J:b  J:c
────────────┼──────────────────────────────────────────────────────────────
A           │   2    2    2    0    0    0  …    0    0    0    0    0    0
B           │   0    0    0    2    2    2       0    0    0    0    0    0
C           │   0    0    0    0    0    0       0    0    0    0    0    0
D           │   0    0    0    0    0    0       0    0    0    0    0    0
E           │   0    0    0    0    0    0       0    0    0    0    0    0
F           │   0    0    0    0    0    0       0    0    0    0    0    0
G           │   0    0    0    0    0    0       0    0    0    0    0    0
H           │   0    0    0    0    0    0       0    0    0    0    0    0
I           │   0    0    0    0    0    0       2    2    2    0    0    0
J           │   0    0    0    0    0    0  …    0    0    0    2    2    2
</code></pre>
When plotting the strength versus sample and in the data we should remember that we have two strength measurements on each of the 30 samples. It is tempting to use the cask designation (‘a’, ‘b’ and ‘c’) to determine, say, the plotting symbol within a sample. It would be fine to do this within a batch but the plot would be misleading if we used the same symbol for cask ‘a’ in different batches. There is no relationship between cask ‘a’ in batch ‘A’ and cask ‘a’ in batch ‘B’. The labels ‘a’, ‘b’ and ‘c’ are used only to distinguish the three samples within a batch; they do not have a meaning across batches.

Strength of paste preparations according to the and the within the batch. There were two strength measurements on each of the 30 samples; three samples each from 10 batches.

[fig:Pastesplot]

In Fig. [fig:Pastesplot] we plot the two strength measurements on each of the samples within each of the batches and join up the average strength for each sample. The perceptive reader will have noticed that the levels of the factors on the vertical axis in this figure, and in Fig. [fig:Dyestuffdot] and [fig:Penicillindot], have been reordered according to increasing average response. In all these cases there is no inherent ordering of the levels of the covariate such as or . Rather than confuse our interpretation of the plot by determining the vertical displacement of points according to a random ordering, we impose an ordering according to increasing mean response. This allows us to more easily check for structure in the data, including undesirable characteristics like increasing variability of the response with increasing mean level of the response.

In Fig. [fig:Pastesplot] we order the samples within each batch separately then order the batches according to increasing mean strength.

Figure [fig:Pastesplot] shows considerable variability in strength between samples relative to the variability within samples. There is some indication of variability between batches, in addition to the variability induced by the samples, but not a strong indication of a batch effect. For example, batches I and D, with low mean strength relative to the other batches, each contained one sample (I:b and D:c, respectively) that had high mean strength relative to the other samples. Also, batches H and C, with comparatively high mean batch strength, contain samples H:a and C:a with comparatively low mean sample strength. In Sect. [sec:TestingSig2is0] we will examine the need for incorporating batch-to-batch variability, in addition to sample-to-sample variability, in the statistical model.

Nested Factors
Because each level of occurs with one and only one level of we say that is nested within . Some presentations of mixed-effects models, especially those related to multilevel modeling  or hierarchical linear models , leave the impression that one can only define random effects with respect to factors that are nested. This is the origin of the terms “multilevel”, referring to multiple, nested levels of variability, and “hierarchical”, also invoking the concept of a hierarchy of levels. To be fair, both those references do describe the use of models with random effects associated with non-nested factors, but such models tend to be treated as a special case.

The blurring of mixed-effects models with the concept of multiple, hierarchical levels of variation results in an unwarranted emphasis on “levels” when defining a model and leads to considerable confusion. It is perfectly legitimate to define models having random effects associated with non-nested factors. The reasons for the emphasis on defining random effects with respect to nested factors only are that such cases do occur frequently in practice and that some of the computational methods for estimating the parameters in the models can only be easily applied to nested factors.

This is not the case for the methods used in the package. Indeed there is nothing special done for models with random effects for nested factors. When random effects are associated with multiple factors exactly the same computational methods are used whether the factors form a nested sequence or are partially crossed or are completely crossed. There is, however, one aspect of nested grouping factors that we should emphasize, which is the possibility of a factor that is implicitly nested within another factor. Suppose, for example, that the factor was defined as having three levels instead of 30 with the implicit assumption that is nested within . It may seem silly to try to distinguish 30 different batches with only three levels of a factor but, unfortunately, data are frequently organized and presented like this, especially in text books. The factor in the data is exactly such an implicitly nested factor. If we cross-tabulate cask and batch
<pre><code>
        batch
    cask A B C D E F G H I J
       a 2 2 2 2 2 2 2 2 2 2
       b 2 2 2 2 2 2 2 2 2 2
       c 2 2 2 2 2 2 2 2 2 2
</code></pre>       
we get the impression that the and factors are crossed, not nested. If we know that the cask should be considered as nested within the batch then we should create a new categorical variable giving the batch-cask combination, which is exactly what the factor is. A simple way to create such a factor is to use the interaction operator, ‘’, on the factors. It is advisable, but not necessary, to apply to the result thereby dropping unused levels of the interaction from the set of all possible levels of the factor. (An “unused level” is a combination that does not occur in the data.) A convenient code idiom is

or

In a small data set like we can quickly detect a factor being implicitly nested within another factor and take appropriate action. In a large data set, perhaps hundreds of thousands of test scores for students in thousands of schools from hundreds of school districts, it is not always obvious if school identifiers are unique across the entire data set or just within a district. If you are not sure, the safest thing to do is to create the interaction factor, as shown above, so you can be confident that levels of the district:school interaction do indeed correspond to unique schools.

Fitting a Model With Nested Random Effects
Fitting a model with simple, scalar random effects for nested factors is done in exactly the same way as fitting a model with random effects for crossed grouping factors. We include random-effects terms for each factor, as in

julia> pstsm = fit!(LinearMixedModel(@formula(Y ~ 1 + (1|G) + (1|H)), dat[:Pastes]))
Linear mixed model fit by maximum likelihood
 Formula: Y ~ 1 + (1 | G) + (1 | H)
   logLik   -2 logLik     AIC        BIC    
 -123.99723  247.99447  255.99447  264.37184

Variance components:
              Column    Variance  Std.Dev.  
 G        (Intercept)  8.4336167 2.90406899
 H        (Intercept)  1.1991787 1.09507018
 Residual              0.6780021 0.82340886
 Number of obs: 60; levels of grouping factors: 30, 10

  Fixed-effects parameters:
             Estimate Std.Error z value P(>|z|)
(Intercept)   60.0533  0.642136 93.5212  <1e-99

Not only is the model specification similar for nested and crossed factors, the internal calculations are performed according to the methods described in Sect. [sec:definitions] for each model type. Comparing the patterns in the matrices Λ, Z′Z and L for this model (Fig. [fig:fm04LambdaLimage]) to those in Fig. [fig:fm03LambdaLimage] shows that models with nested factors produce simple repeated structures along the diagonal of the sparse Cholesky factor, L. This type of structure has the desirable property that there is no “fill-in” during calculation of the Cholesky factor. In other words, the number of non-zeros in L is the same as the number of non-zeros in the lower triangle of the matrix being factored, Λ′Z′ZΛ+I (which, because Λ is diagonal, has the same structure as Z′Z).

Assessing Parameter Estimates in Model pstsm
The parameter estimates are: σ1ˆ=2.904, the standard deviation of the random effects for sample; σ2ˆ=1.095, the standard deviation of the random effects for batch; σˆ=0.823, the standard deviation of the residual noise term; and β0ˆ=60.053, the overall mean response, which is labeled (Intercept) in these models.

The estimated standard deviation for sample is nearly three times as large as that for batch, which confirms what we saw in Fig. [fig:Pastesplot]. Indeed our conclusion from Fig. [fig:Pastesplot] was that there may not be a significant batch-to-batch variability in addition to the sample-to-sample variability.

Plots of the prediction intervals of the random effects (Fig. [fig:fm04ranef])

95% prediction intervals on the random effects for model fit to the data.

[fig:fm04ranef]

confirm this impression in that all the prediction intervals for the random effects for contain zero. Furthermore, a bootstrap sample

julia> Random.seed!(4321234);

julia> @time pstsbstp = bootstrap(10000, pstsm);
 17.509696 seconds (67.42 M allocations: 2.024 GiB, 4.36% gc time)


julia> plot(pstsbstp, x = :σ, density, xlabel("σ"))
Plot(...)
julia> plot(x = pstsbstp[:σ₁], Geom.density(), Guide.xlabel("σ₁"))
Plot(...)
julia> plot(x = pstsbstp[:σ₂], Geom.density(), Guide.xlabel("σ₂"))
Plot(...)
and a normal probability plot of

julia> plot(x = zquantiles, y = quantile(pstsbstp[:σ₂], ppt250), Geom.line,
    Guide.xlabel("Standard Normal Quantiles"), Guide.ylabel("σ₂"))
Plot(...)
julia> count(x -> x < 1.0e-5, pstsbstp[:σ₂])
3671
Over 1/3 of the bootstrap samples of σ2 are zero. Even a 50% confidence interval on this parameter will extend to zero. One way to calculate confidence intervals based on a bootstrap sample is sort the sample and consider all the contiguous intervals that contain, say, 95% of the samples then choose the smallest of these. For example,

julia> hpdinterval(pstsbstp[:σ₂])
2-element Array{Float64,1}:
 0.0              
 2.073479680297123
provides the confidence interval

Profile zeta plots for the parameters in model .

[fig:fm04prplot]

shows that the even the 50% profile-based confidence interval on σ2 extends to zero.

Because there are several indications that σ2 could reasonably be zero, resulting in a simpler model incorporating random effects for only, we perform a statistical test of this hypothesis.

Testing H0:σ2=0 Versus Ha:σ2>0
One of the many famous statements attributed to Albert Einstein is “Everything should be made as simple as possible, but not simpler.” In statistical modeling this principal of parsimony is embodied in hypothesis tests comparing two models, one of which contains the other as a special case. Typically, one or more of the parameters in the more general model, which we call the alternative hypothesis, is constrained in some way, resulting in the restricted model, which we call the null hypothesis. Although we phrase the hypothesis test in terms of the parameter restriction, it is important to realize that we are comparing the quality of fits obtained with two nested models. That is, we are not assessing parameter values per se; we are comparing the model fit obtainable with some constraints on parameter values to that without the constraints.

Because the more general model, Ha, must provide a fit that is at least as good as the restricted model, H0, our purpose is to determine whether the change in the quality of the fit is sufficient to justify the greater complexity of model Ha. This comparison is often reduced to a p-value, which is the probability of seeing a difference in the model fits as large as we did, or even larger, when, in fact, H0 is adequate. Like all probabilities, a p-value must be between 0 and 1. When the p-value for a test is small (close to zero) we prefer the more complex model, saying that we “reject H0 in favor of Ha”. On the other hand, when the p-value is not small we “fail to reject H0”, arguing that there is a non-negligible probability that the observed difference in the model fits could reasonably be the result of random chance, not the inherent superiority of the model Ha. Under these circumstances we prefer the simpler model, H0, according to the principal of parsimony.

These are the general principles of statistical hypothesis tests. To perform a test in practice we must specify the criterion for comparing the model fits, the method for calculating the p-value from an observed value of the criterion, and the standard by which we will determine if the p-value is “small” or not. The criterion is called the test statistic, the p-value is calculated from a reference distribution for the test statistic, and the standard for small p-values is called the level of the test.

In Sect. [sec:variability] we referred to likelihood ratio tests (LRTs) for which the test statistic is the difference in the deviance. That is, the LRT statistic is d0−da where da is the deviance in the more general (Ha) model fit and d0 is the deviance in the constrained (H0) model. An approximate reference distribution for an LRT statistic is the χ2ν distribution where ν, the degrees of freedom, is determined by the number of constraints imposed on the parameters of Ha to produce H0.

The restricted model fit

julia> pstsm1 = fit!(LinearMixedModel(@formula(Y ~ 1 + (1|G)), dat[:Pastes]))
Linear mixed model fit by maximum likelihood
 Formula: Y ~ 1 + (1 | G)
   logLik   -2 logLik     AIC        BIC    
 -124.20085  248.40170  254.40170  260.68473

Variance components:
              Column    Variance   Std.Dev. 
 G        (Intercept)  9.63282202 3.1036788
 Residual              0.67800001 0.8234076
 Number of obs: 60; levels of grouping factors: 30

  Fixed-effects parameters:
             Estimate Std.Error z value P(>|z|)
(Intercept)   60.0533  0.576536 104.162  <1e-99

is compared to model pstsm with

julia> MixedModels.lrt(pstsm1, pstsm)
2×4 DataFrame
│ Row │ Df    │ Deviance │ Chisq    │ pval     │
│     │ Int64 │ Float64  │ Float64  │ Float64  │
├─────┼───────┼──────────┼──────────┼──────────┤
│ 1   │ 3     │ 248.402  │ NaN      │ NaN      │
│ 2   │ 4     │ 247.994  │ 0.407234 │ 0.523377 │
which provides a p-value of 0.5234. Because typical standards for “small” p-values are 5% or 1%, a p-value over 50% would not be considered significant at any reasonable level.

We do need to be cautious in quoting this p-value, however, because the parameter value being tested, σ2=0, is on the boundary of set of possible values, σ2≥0, for this parameter. The argument for using a χ21 distribution to calculate a p-value for the change in the deviance does not apply when the parameter value being tested is on the boundary. As shown in Pinheiro and Bates (2000), the p-value from the χ21 distribution will be “conservative” in the sense that it is larger than a simulation-based p-value would be. In the worst-case scenario the χ2-based p-value will be twice as large as it should be but, even if that were true, an effective p-value of 26% would not cause us to reject H0 in favor of Ha.

Assessing the Reduced Model, pstsm1
A bootstrap sample

julia> @time psts1bstp = bootstrap(10000, pstsm1);
  6.902661 seconds (23.19 M allocations: 700.737 MiB, 4.32% gc time)
provides empirical density plots



and



The profile zeta plots for the remaining parameters in model (Fig. [fig:fm04aprplot])

Profile zeta plots for the parameters in model .

[fig:fm04aprplot]

are similar to the corresponding panels in Fig. [fig:fm04prplot], as confirmed by the numerical values of the confidence intervals.

                     2.5 %    97.5 %
    .sig01       2.1579337  4.053589
    .sig02       0.0000000  2.946591
    .sigma       0.6520234  1.085448
    (Intercept) 58.6636504 61.443016
                     2.5 %    97.5 %
    .sig01       2.4306377  4.122011
    .sigma       0.6520207  1.085448
    (Intercept) 58.8861831 61.220484
The confidence intervals on log(σ) and β0 are similar for the two models. The confidence interval on σ1 is slightly wider in model pstsm1 than in pstsm, because the variability that is attributed to σ2 in pstsm is incorporated into the variability due to σ1 in pstsm1.

Profile pairs plot for the parameters in model fit to the data.

[fig:fm04aprpairs]

The patterns in the profile pairs plot (Fig. [fig:fm04aprpairs]) for the reduced model are similar to those in Fig. [fig:fm1profpair], the profile pairs plot for model .

A Model With Partially Crossed Random Effects
Especially in observational studies with multiple grouping factors, the configuration of the factors frequently ends up neither nested nor completely crossed. We describe such situations as having partially crossed grouping factors for the random effects.

Studies in education, in which test scores for students over time are also associated with teachers and schools, usually result in partially crossed grouping factors. If students with scores in multiple years have different teachers for the different years, the student factor cannot be nested within the teacher factor. Conversely, student and teacher factors are not expected to be completely crossed. To have complete crossing of the student and teacher factors it would be necessary for each student to be observed with each teacher, which would be unusual. A longitudinal study of thousands of students with hundreds of different teachers inevitably ends up partially crossed.

In this section we consider an example with thousands of students and instructors where the response is the student’s evaluation of the instructor’s effectiveness. These data, like those from most large observational studies, are quite unbalanced.

The InstEval Data
The data are from a special evaluation of lecturers by students at the Swiss Federal Institute for Technology–Zürich (ETH–Zürich), to determine who should receive the “best-liked professor” award. These data have been slightly simplified and identifying labels have been removed, so as to preserve anonymity.

The variables

julia> names(dat[:InstEval])
7-element Array{Symbol,1}:
 :G      
 :H      
 :studage
 :lectage
 :A      
 :I      
 :Y      
have somewhat cryptic names. Factor s designates the student and d the instructor. The factor dept is the department for the course and service indicates whether the course was a service course taught to students from other departments.

Although the response, Y, is on a scale of 1 to 5,

julia> freqtable(dat[:InstEval][:Y])'
1×5 Named Adjoint{Int64,Array{Int64,1}}
' ╲ Dim1 │     1      2      3      4      5
─────────┼──────────────────────────────────
1        │ 10186  12951  17609  16921  15754
it is sufficiently diffuse to warrant treating it as if it were a continuous response.

At this point we will fit models that have random effects for student, instructor, and department (or the combination) to these data. In the next chapter we will fit models incorporating fixed-effects for instructor and department to these data.

julia> @time instm = fit(LinearMixedModel, @formula(Y ~ 1 + A + (1|G) + (1|H) + (1|I)), dat[:InstEval])
  3.911847 seconds (2.74 M allocations: 323.059 MiB, 8.79% gc time)
Linear mixed model fit by maximum likelihood
 Formula: Y ~ 1 + A + (1 | G) + (1 | H) + (1 | I)
     logLik        -2 logLik          AIC             BIC       
 -1.18860884×10⁵  2.37721769×10⁵  2.37733769×10⁵  2.37788993×10⁵

Variance components:
              Column     Variance    Std.Dev. 
 G        (Intercept)  0.1059727787 0.3255346
 H        (Intercept)  0.2652041783 0.5149798
 I        (Intercept)  0.0061673544 0.0785325
 Residual              1.3864885827 1.1774925
 Number of obs: 73421; levels of grouping factors: 2972, 1128, 14

  Fixed-effects parameters:
               Estimate Std.Error  z value P(>|z|)
(Intercept)     3.28258  0.028411  115.539  <1e-99
A: 1         -0.0925886 0.0133832 -6.91828  <1e-11

(Fitting this complex model to a moderately large data set takes a few seconds on a modest desktop computer. Although this is more time than required for earlier model fits, it is a remarkably short time for fitting a model of this size and complexity. In some ways it is remarkable that such a model can be fit at all on such a computer.)

All three estimated standard deviations of the random effects are less than σˆ, with σˆ3, the estimated standard deviation of the random effects for dept, less than one-tenth of σˆ.

It is not surprising that zero is within all of the prediction intervals on the random effects for this factor (Fig. [fig:fm05ranef]). In fact, zero is close to the middle of all these prediction intervals. However, the p-value for the LRT of H0:σ3=0 versus Ha:σ3>0


Data: InstEval
Models:
fm05a: y ~ 1 + (1 | s) + (1 | d)
fm05: y ~ 1 + (1 | s) + (1 | d) + (1 | dept:service)
      Df    AIC    BIC  logLik deviance  Chisq Chi Df Pr(>Chisq)
fm05a  4 237786 237823 -118889   237778                         
fm05   5 237663 237709 -118827   237653 124.43      1  < 2.2e-16
is highly significant. That is, we have very strong evidence that we should reject H0 in favor of Ha.

The seeming inconsistency of these conclusions is due to the large sample size (n=73421). When a model is fit to a very large sample even the most subtle of differences can be highly “statistically significant”. The researcher or data analyst must then decide if these terms have practical significance, beyond the apparent statistical significance.

The large sample size also helps to assure that the parameters have good normal approximations. We could profile this model fit but doing so would take a very long time and, in this particular case, the analysts are more interested in a model that uses fixed-effects parameters for the instructors, which we will describe in the next chapter.

We could pursue other mixed-effects models here, such as using the factor and not the interaction to define random effects, but we will revisit these data in the next chapter and follow up on some of these variations there.

Image of the sparse Cholesky factor, \$\\mathbf L\$, from model 

[fig:fm05Limage]

Chapter Summary
A simple, scalar random effects term in an model formula is of the form , where is an expression whose value is the grouping factor of the set of random effects generated by this term. Typically, is simply the name of a factor, such as in the terms or in the examples in this chapter. However, the grouping factor can be the value of an expression, such as in the last example.

Because simple, scalar random-effects terms can differ only in the description of the grouping factor we refer to configurations such as crossed or nested as applying to the terms or to the random effects, although it is more accurate to refer to the configuration as applying to the grouping factors.

A model formula can include several such random effects terms. Because configurations such as nested or crossed or partially crossed grouping factors are a property of the data, the specification in the model formula does not depend on the configuration. We simply include multiple random effects terms in the formula specifying the model.

One apparent exception to this rule occurs with implicitly nested factors, in which the levels of one factor are only meaningful within a particular level of the other factor. In the data, levels of the factor are only meaningful within a particular level of the factor. A model formula of

strength ~ 1 + (1 | cask) + (1 | batch)
would result in a fitted model that did not appropriately reflect the sources of variability in the data. Following the simple rule that the factor should be defined so that distinct experimental or observational units correspond to distinct levels of the factor will avoid such ambiguity.

For convenience, a model with multiple, nested random-effects terms can be specified as

strength ~ 1 + (1 | batch/cask)
which internally is re-expressed as

strength ~ 1 + (1 | batch) + (1 | batch:cask)
We will avoid terms of the form , preferring instead an explicit specification with simple, scalar terms based on unambiguous grouping factors.

The data, described in Sec. [sec:InstEval], illustrate some of the characteristics of the real data to which mixed-effects models are now fit. There is a large number of observations associated with several grouping factors; two of which, student and instructor, have a large number of levels and are partially crossed. Such data are common in sociological and educational studies but until now it has been very difficult to fit models that appropriately reflect such a structure. Much of the literature on mixed-effects models leaves the impression that multiple random effects terms can only be associated with nested grouping factors. The resulting emphasis on hierarchical or multilevel configurations is an artifact of the computational methods used to fit the models, not the models themselves.

The parameters of the models fit to small data sets have properties similar to those for the models in the previous chapter. That is, profile-based confidence intervals on the fixed-effects parameter, β0, are symmetric about the estimate but overdispersed relative to those that would be calculated from a normal distribution and the logarithm of the residual standard deviation, log(σ), has a good normal approximation. Profile-based confidence intervals for the standard deviations of random effects (σ1, σ2, etc.) are symmetric on a logarithmic scale except for those that could be zero.

Another observation from the last example is that, for data sets with a very large numbers of observations, a term in a model may be “statistically significant” even when its practical significance is questionable.

#### Exercises
These exercises use data sets from the package for . Recall that to access a particular data set, you must either attach the package

or load just the one data set


We begin with exercises using the ergostool data from the nlme package. The analysis and graphics in these exercises is performed in Chap. [chap:Covariates]. The purpose of these exercises is to see if you can use the material from this chapter to anticipate the results quoted in the next chapter.

Check the documentation, the structure () and a summary of the data from the package. (If you are familiar with the Star Trek television series and movies, you may want to speculate about what, exactly, the “Borg scale” is.) Are these factors are nested, partially crossed or completely crossed. Is this a replicated or an unreplicated design?

Create a plot, similar to Fig. [fig:Penicillindot], showing the effort by subject with lines connecting points corresponding to the same stool types. Order the levels of the factor by increasing average .

The experimenters are interested in comparing these specific stool types. In the next chapter we will fit a model with fixed-effects for the factor and random effects for , allowing us to perform comparisons of these specific types. At this point fit a model with random effects for both and . What are the relative sizes of the estimates of the standard deviations, σˆ1 (for ), σˆ2 (for ) and σˆ (for the residual variability)?

Refit the model using maximum likelihood. Check the parameter estimates and, in the case of the fixed-effects parameter, β0, its standard error. In what ways have the parameter estimates changed? Which parameter estimates have not changed?

Profile the fitted model and construct 95% profile-based confidence intervals on the parameters. (Note that you will get the same profile object whether you start with the REML fit or the ML fit. There is a slight advantage in starting with the ML fit.) Is the confidence interval on σ1 close to being symmetric about its estimate? Is the confidence interval on σ2 close to being symmetric about its estimate? Is the corresponding interval on log(σ1) close to being symmetric about its estimate?

Create the profile zeta plot for this model. For which parameters are there good normal approximations?

Create a profile pairs plot for this model. Comment on the shapes of the profile traces in the transformed (ζ) scale and the shapes of the contours in the original scales of the parameters.

Create a plot of the 95% prediction intervals on the random effects for using (Substitute the name of your fitted model for in the call to .) Is there a clear winner among the stool types? (Assume that lower numbers on the Borg scale correspond to less effort).

Create a plot of the 95% prediction intervals on the random effects for .

Check the documentation, the structure () and a summary of the data from the package. Use a cross-tabulation to discover whether and are nested, partially crossed or completely crossed.

Fit a model of the in the data with random effects for , and .

Plot the prediction intervals for each of the three sets of random effects.

Profile the parameters in this model. Create a profile zeta plot. Does including the random effect for appear to be warranted. Does your conclusion from the profile zeta plot agree with your conclusion from examining the prediction intervals for the random effects for ?

Refit the model without random effects for . Perform a likelihood ratio test of H0:σ3=0 versus Ha:σ3>0. Would you reject H0 in favor of Ha or fail to reject H0? Would you reach the same conclusion if you adjusted the p-value for the test by halving it, to take into account the fact that 0 is on the boundary of the parameter region?

Profile the reduced model (i.e. the one without random effects for ) and create profile zeta and profile pairs plots. Can you explain the apparent interaction between log(σ) and σ1? (This is a difficult question.)

PreviousA Simple, Linear, Mixed-effects ModelNextSingular covariance estimates in random regression models
