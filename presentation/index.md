Shiny App: mtcars-lm
========================================================

An interactive web application to explore the relationship between MPG and other car characteristics.

Goals of the application
========================================================

* Exploration of the linear model of MPG against other variables
* The data set:
    - A data frame with 32 observations on 11 variables
    - From R documentation;
    - List of variable on next slide.
* The application allows the user to specify:
    - What variables to use as regressors;
    - Whether to include the intercept.

The variables
========================================================

Variable | Explanation
---------|-------------
mpg	 | Miles/(US) gallon
cyl	 | Number of cylinders
disp | Displacement (cu.in.)
hp	 | Gross horsepower
drat | Rear axle ratio
wt	 | Weight (lb/1000)
qsec | 1/4 mile time
vs	 | V/S
am	 | Transmission (0 = automatic, 1 = manual)
gear | Number of forward gears
carb | Number of carburetors

User interface
========================================================

* The user has two input fields:
    - Multiple-input field for variable names
    - Checkbox for intercept inclusion
* Three tabs for display:
    1. Regression results with coefficients and statistics;
    2. Raw data in tabular form
    3. Documentation

Regression
========================================================

* If the user selects 'wt' and 'hp' as variables this is what gets calculated:

```r
library(xtable)
data(mtcars)
fit <- lm(mpg ~ wt + hp, data=mtcars)
print(xtable(fit), type='html')
```

<!-- html table generated in R 3.1.0 by xtable 1.7-3 package -->
<!-- Mon Sep 22 02:04:06 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> Estimate </TH> <TH> Std. Error </TH> <TH> t value </TH> <TH> Pr(&gt;|t|) </TH>  </TR>
  <TR> <TD align="right"> (Intercept) </TD> <TD align="right"> 37.2273 </TD> <TD align="right"> 1.5988 </TD> <TD align="right"> 23.28 </TD> <TD align="right"> 0.0000 </TD> </TR>
  <TR> <TD align="right"> wt </TD> <TD align="right"> -3.8778 </TD> <TD align="right"> 0.6327 </TD> <TD align="right"> -6.13 </TD> <TD align="right"> 0.0000 </TD> </TR>
  <TR> <TD align="right"> hp </TD> <TD align="right"> -0.0318 </TD> <TD align="right"> 0.0090 </TD> <TD align="right"> -3.52 </TD> <TD align="right"> 0.0015 </TD> </TR>
   </TABLE>

