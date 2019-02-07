MixedModels logo
MixedModels


Search docs
MixedModels.jl Documentation
Model constructors
Details of the parameter estimation
Normalized Gauss-Hermite Quadrature
Parametric bootstrap for linear mixed-effects models
A Simple, Linear, Mixed-effects Model
Models With Multiple Random-effects Terms
A Model With Crossed Random Effects
A Model With Nested Random Effects
A Model With Partially Crossed Random Effects
Chapter Summary
Exercises
Singular covariance estimates in random regression models
-
Benchmark Report for /home/bates/.julia/packages/MixedModels/dn0WY/src/MixedModels.jl

odels With Multiple Random-effects Terms Edit on GitHub
Models With Multiple Random-effects Terms
The mixed models considered in the previous chapter had only one random-effects term, which was a simple, scalar random-effects term, and a single fixed-effects coefficient. Although such models can be useful, it is with the facility to use multiple random-effects terms and to use random-effects terms beyond a simple, scalar term that we can begin to realize the flexibility and versatility of mixed models.

In this chapter we consider models with multiple simple, scalar random-effects terms, showing examples where the grouping factors for these terms are in completely crossed or nested or partially crossed configurations. For ease of description we will refer to the random effects as being crossed or nested although, strictly speaking, the distinction between nested and non-nested refers to the grouping factors, not the random effects.

<pre><code>
julia> using DataFrames, Distributions, FreqTables, MixedModels, RData, Random

julia> using Gadfly

julia> using Gadfly.Geom: density, histogram, line, point

julia> using Gadfly.Guide: xlabel, ylabel

julia> const dat = Dict(Symbol(k)=>v for (k,v) in 
    load(joinpath(dirname(pathof(MixedModels)), "..", "test", "dat.rda")));

julia> const ppt250 = inv(500) : inv(250) : 1.;

julia> const zquantiles = quantile(Normal(), ppt250);

julia> function hpdinterval(v, level=0.95)
    n = length(v)
    if !(0 < level < 1)
        throw(ArgumentError("level = $level must be in (0, 1)"))
    end
    if (lbd = floor(Int, (1 - level) * n)) < 2
        throw(ArgumentError(
            "level = $level is too large from sample size $n"))
    end
    ordstat = sort(v)
    leftendpts = ordstat[1:lbd]
    rtendpts = ordstat[(1 + n - lbd):n]
    (w, ind) = findmin(rtendpts - leftendpts)
    return [leftendpts[ind], rtendpts[ind]]
end
hpdinterval (generic function with 2 methods)
</code></pre>

##### A Model With Crossed Random Effects
One of the areas in which the methods in the package for are particularly effective is in fitting models to cross-classified data where several factors have random effects associated with them. For example, in many experiments in psychology the reaction of each of a group of subjects to each of a group of stimuli or items is measured. If the subjects are considered to be a sample from a population of subjects and the items are a sample from a population of items, then it would make sense to associate random effects with both these factors.

In the past it was difficult to fit mixed models with multiple, crossed grouping factors to large, possibly unbalanced, data sets. The methods in the package are able to do this. To introduce the methods let us first consider a small, balanced data set with crossed grouping factors.

#### The Penicillin Data
The data are derived from Table 6.6, p. 144 of Davies (), where they are described as coming from an investigation to

assess the variability between samples of penicillin by the B. subtilis method. In this test method a bulk-innoculated nutrient agar medium is poured into a Petri dish of approximately 90 mm. diameter, known as a plate. When the medium has set, six small hollow cylinders or pots (about 4 mm. in diameter) are cemented onto the surface at equally spaced intervals. A few drops of the penicillin solutions to be compared are placed in the respective cylinders, and the whole plate is placed in an incubator for a given time. Penicillin diffuses from the pots into the agar, and this produces a clear circular zone of inhibition of growth of the organisms, which can be readily measured. The diameter of the zone is related in a known way to the concentration of penicillin in the solution.

<pre><code>
julia> describe(dat[:Penicillin])
3×8 DataFrame. Omitted printing of 1 columns
│ Row │ variable │ mean    │ min  │ median │ max  │ nunique │ nmissing │
│     │ Symbol   │ Union…  │ Any  │ Union… │ Any  │ Union…  │ Nothing  │
├─────┼──────────┼─────────┼──────┼────────┼──────┼─────────┼──────────┤
│ 1   │ Y        │ 22.9722 │ 18.0 │ 23.0   │ 27.0 │         │          │
│ 2   │ G        │         │ a    │        │ x    │ 24      │          │
│ 3   │ H        │         │ A    │        │ F    │ 6       │          │
</code></pre>
of the data, then plot it

The variation in the diameter is associated with the plates and with the samples. Because each plate is used only for the six samples shown here we are not interested in the contributions of specific plates as much as we are interested in the variation due to plates and in assessing the potency of the samples after accounting for this variation. Thus, we will use random effects for the factor. We will also use random effects for the factor because, as in the Dyestuff example, we are more interested in the sample-to-sample variability in the penicillin samples than in the potency of a particular sample.

In this experiment each sample is used on each plate. We say that the and factors are crossed, as opposed to nested factors, which we will describe in the next section. By itself, the designation “crossed” just means that the factors are not nested. If we wish to be more specific, we could describe these factors as being completely crossed, which means that we have at least one observation for each combination of a level of G and a level of H. We can see this in Fig. [fig:Penicillindot] and, because there are moderate numbers of levels in these factors, we can check it in a cross-tabulation
<pre><code>
julia> freqtable(dat[:Penicillin][:H], dat[:Penicillin][:G])
6×24 Named Array{Int64,2}
Dim1 ╲ Dim2 │ a  b  c  d  e  f  g  h  i  j  …  o  p  q  r  s  t  u  v  w  x
────────────┼──────────────────────────────────────────────────────────────
A           │ 1  1  1  1  1  1  1  1  1  1  …  1  1  1  1  1  1  1  1  1  1
B           │ 1  1  1  1  1  1  1  1  1  1     1  1  1  1  1  1  1  1  1  1
C           │ 1  1  1  1  1  1  1  1  1  1     1  1  1  1  1  1  1  1  1  1
D           │ 1  1  1  1  1  1  1  1  1  1     1  1  1  1  1  1  1  1  1  1
E           │ 1  1  1  1  1  1  1  1  1  1     1  1  1  1  1  1  1  1  1  1
F           │ 1  1  1  1  1  1  1  1  1  1  …  1  1  1  1  1  1  1  1  1  1
</code></pre>

Like the Dyestuff data, the factors in the Penicillin data are balanced. That is, there are exactly the same number of observations on each plate and for each sample and, furthermore, there is the same number of observations on each combination of levels. In this case there is exactly one observation for each combination of G, the plate, and H, the sample. We would describe the configuration of these two factors as an unreplicated, completely balanced, crossed design.

In general, balance is a desirable but precarious property of a data set. We may be able to impose balance in a designed experiment but we typically cannot expect that data from an observation study will be balanced. Also, as anyone who analyzes real data soon finds out, expecting that balance in the design of an experiment will produce a balanced data set is contrary to “Murphy’s Law”. That’s why statisticians allow for missing data. Even when we apply each of the six samples to each of the 24 plates, something could go wrong for one of the samples on one of the plates, leaving us without a measurement for that combination of levels and thus an unbalanced data set.

### A Model For the Penicillin Data
A model incorporating random effects for both the plate and the sample is straightforward to specify — we include simple, scalar random effects terms for both these factors.
<pre><code>
julia> penm = fit(LinearMixedModel, @formula(Y ~ 1 + (1|G) + (1|H)), dat[:Penicillin])
Linear mixed model fit by maximum likelihood
 Formula: Y ~ 1 + (1 | G) + (1 | H)
   logLik   -2 logLik     AIC        BIC    
 -166.09417  332.18835  340.18835  352.06760

Variance components:
              Column    Variance   Std.Dev. 
 G        (Intercept)  0.71497949 0.8455646
 H        (Intercept)  3.13519326 1.7706477
 Residual              0.30242640 0.5499331
 Number of obs: 144; levels of grouping factors: 24, 6

  Fixed-effects parameters:
             Estimate Std.Error z value P(>|z|)
(Intercept)   22.9722  0.744596 30.8519  <1e-99
</code></pre>

This model display indicates that the sample-to-sample variability has the greatest contribution, then plate-to-plate variability and finally the “residual” variability that cannot be attributed to either the sample or the plate. These conclusions are consistent with what we see in the data plot (Fig. [fig:Penicillindot]).

The prediction intervals on the random effects (Fig. [fig:fm03ranef])

confirm that the conditional distribution of the random effects for has much less variability than does the conditional distribution of the random effects for , in the sense that the dots in the bottom panel have less variability than those in the top panel. (Note the different horizontal axes for the two panels.) However, the conditional distribution of the random effect for a particular , say sample F, has less variability than the conditional distribution of the random effect for a particular plate, say plate m. That is, the lines in the bottom panel are wider than the lines in the top panel, even after taking the different axis scales into account. This is because the conditional distribution of the random effect for a particular sample depends on 24 responses while the conditional distribution of the random effect for a particular plate depends on only 6 responses.

In chapter [chap:ExamLMM] we saw that a model with a single, simple, scalar random-effects term generated a random-effects model matrix, Z, that is the matrix of indicators of the levels of the grouping factor. When we have multiple, simple, scalar random-effects terms, as in model , each term generates a matrix of indicator columns and these sets of indicators are concatenated to form the model matrix Z. The transpose of this matrix, shown in Fig. [fig:fm03Ztimage], contains rows of indicators for each factor.

The relative covariance factor, Λθ, (Fig. [fig:fm03LambdaLimage], left panel) is no longer a multiple of the identity. It is now block diagonal, with two blocks, one of size 24 and one of size 6, each of which is a multiple of the identity. The diagonal elements of the two blocks are θ1 and θ2, respectively. The numeric values of these parameters can be obtained as

<pre><code>
julia> show(getθ(penm))
[1.53758, 3.21975]
or as the Final parameter vector in the opsum field of penm

julia> penm.optsum
Initial parameter vector: [1.0, 1.0]
Initial objective value:  364.62677981659544

Optimizer (from NLopt):   LN_BOBYQA
Lower bounds:             [0.0, 0.0]
ftol_rel:                 1.0e-12
ftol_abs:                 1.0e-8
xtol_rel:                 0.0
xtol_abs:                 [1.0e-10, 1.0e-10]
initial_step:             [0.75, 0.75]
maxfeval:                 -1

Function evaluations:     44
Final parameter vector:   [1.53758, 3.21975]
Final objective value:    332.18834867237246
Return code:              FTOL_REACHED
</code></pre>
The first parameter is the relative standard deviation of the random effects for plate, which has the value 0.8455646/0.5499331 = 1.53758 at convergence, and the second is the relative standard deviation of the random effects for sample (1.7706475/0.5499331 = 3.21975).

Because Λθ is diagonal, the pattern of non-zeros in Λ′θZ′ZΛθ+I will be the same as that in Z′Z, shown in the middle panel of Fig. [fig:fm03LambdaLimage]. The sparse Cholesky factor, L, shown in the right panel, is lower triangular and has non-zero elements in the lower right hand corner in positions where Z′Z has systematic zeros. We say that “fill-in” has occurred when forming the sparse Cholesky decomposition. In this case there is a relatively minor amount of fill but in other cases there can be a substantial amount of fill and we shall take precautions so as to reduce this, because fill-in adds to the computational effort in determining the MLEs or the REML estimates.

A bootstrap simulation of the model
<pre><code>
julia> @time penmbstp = bootstrap(10000, penm);
 24.313179 seconds (83.13 M allocations: 2.532 GiB, 3.95% gc time)
provides the density plots





<pre><code>

julia> plot(penmbstp, x = :σ₂, density, xlabel("σ₂"))
Plot(...)
</code></pre>
A profile zeta plot (Fig. [fig:fm03prplot]) for the parameters in model

Profile zeta plot of the parameters in model .

[fig:fm03prplot]

leads to conclusions similar to those from Fig. [fig:fm1prof] for model in the previous chapter. The fixed-effect parameter, β1, for the constant term has symmetric intervals and is over-dispersed relative to the normal distribution. The logarithm of σ has a good normal approximation but the standard deviations of the random effects, σ1 and σ2, are skewed. The skewness for σ2 is worse than that for σ1, because the estimate of σ2 is less precise than that of σ1, in both absolute and relative senses. For an absolute comparison we compare the widths of the confidence intervals for these parameters.
<pre><code>
                     2.5 %     97.5 %
    .sig01       0.6335658  1.1821040
    .sig02       1.0957893  3.5562919
    .sigma       0.4858454  0.6294535
    (Intercept) 21.2666274 24.6778176
</code></pre>    
In a relative comparison we examine the ratio of the endpoints of the interval divided by the estimate.
<pre><code>

               2.5 %   97.5 %
    .sig01 0.7492746 1.397993
    .sig02 0.6188634 2.008469
</code></pre>    
The lack of precision in the estimate of σ2 is a consequence of only having 6 distinct levels of the factor. The factor, on the other hand, has 24 distinct levels. In general it is more difficult to estimate a measure of spread, such as the standard deviation, than to estimate a measure of location, such as a mean, especially when the number of levels of the factor is small. Six levels are about the minimum number required for obtaining sensible estimates of standard deviations for simple, scalar random effects terms.

shows patterns similar to those in Fig. [fig:fm1profpair] for pairs of parameters in model fit to the data. On the $\gamma$ scale (panels below the diagonal) the profile traces are nearly straight and orthogonal with the exception of the trace of $\gamma$(σ2) on $\gamma$(β0) (the horizontal trace for the panel in the (4,2) position). The pattern of this trace is similar to the pattern of the trace of $\gamma$(σ1) on $\gamma$(β1) in Fig. [fig:fm1profpair]. Moving β0 from its estimate, βˆ0, in either direction will increase the residual sum of squares. The increase in the residual variability is reflected in an increase of one or more of the dispersion parameters. The balanced experimental design results in a fixed estimate of σ and the extra apparent variability must be incorporated into σ1 or σ2.

Contours in panels of parameter pairs on the original scales (i.e. panels above the diagonal) can show considerable distortion from the ideal elliptical shape. For example, contours in the σ2 versus σ1 panel (the (1,2) position) and the log(σ) versus σ2 panel (in the (2,3) position) are dramatically non-elliptical. However, the distortion of the contours is not due to these parameter estimates depending strongly on each other. It is almost entirely due to the choice of scale for σ1 and σ2. When we plot the contours on the scale of log(σ1) and log(σ2) instead (Fig. [fig:lpr03pairs])

Profile pairs plot for the parameters in model fit to the data. In this plot the parameters \$\\sigma_1\$ and \$\\sigma_2\$ are on the scale of the natural logarithm, as is the parameter \$\\sigma\$ in this and other profile pairs plots.

[fig:fm03lprpairs]

they are much closer to the elliptical pattern.

Conversely, if we tried to plot contours on the scale of σ21 and σ22 (not shown), they would be hideously distorted.

