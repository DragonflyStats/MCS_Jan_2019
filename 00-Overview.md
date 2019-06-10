
### Introduction

The topic of the research is Method Comparison Studies : i.e. suitable techniques from assessing agreement 
between methods of measurement. This is a commonly encountered problem in medical statistics.

The approaches that are prevalent in scientific literature at the *Bland-Altman plot*, and the accompanying interval, the
*limits of agreement*. This methodology is very prevalent in scientific literature, and Bland-Altman (1986) is one of the most cited papers
of all time.

Fundamentally the Bland-Altman plot is a scatterplot of case-wise differences plotted against case-wise averages of measurements.
The limits of agreement are a 95% probability interval estimate on the distribution of case-wise differences. A basic level of statistical knowledge
is all that is required to create both, which is one of the reasons why the methods are so popular.

There are other approaches that may be applicable, specifically the correlation coefficient and regression analysis, but it can be shown that these approaches 
are insufficient for properly assessing agreement.

A further considersation is the matter of replicate measurements. i.e. multiple measurements made by the same measurement device on
the same person or item. Several papers have addressed the inadequacies of commonly used methods when faced with such data.

Repeatability is the quality that a device would given consistent readings if taking replicate measurements (i.e. the device has agreement with itself).
This is often overlooked, and should be incorporated as much as possible.

### Linear Mixed Effects Models

Two key contributions have use LME models to assess agreement. Carstensen at al (2006-2014) how to improve the estimation of limits of agreement for 
replicate measurements. Roy(2009) proposed an demonstrated a suite of hypothesis tests to assess three key criteria for assessing agreement.

Both approaches are implemented using the Systolic Blood pressure data set that features in several papers concerning method comparison.

A comparison of both approaches yield insights on how to improve upon them. Particularly the specification of complex LME models required for Roy's approach.

Criticism of both approaches would be that one is overly complex, while the other is insufficiently complex.

### Statistical Software Consideration

A key issue in progressing methodology is the limitations of Statistical Software. The main R packages are nlme and lme4.
Roy's approach (i.e. the one with complex models) can only be fitted with nlme. The goal is to fit an adequate, but simpler, model using only
lme4.

### Model Diagnostic Methods

There is a discussion on how to investiage influential cases in a way that is suitable to the method comparison problem.
