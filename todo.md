# To do

- Document how we recover the hospitalization data before April 2nd for Ontario.

- We want to have two pipeline 
	1. one for simple testing counts and hospitalization numbers (w.e we have right now); 
	2. combo-dat: a merged dataset with more info (Currently only AB has a combo dataset.)

- What do we really want to show on the front page?

- think about how to link our products (plots, csv and etc...)

- recalculate new reports properly (i.e. join the clean dataset to a complete date dataframe to automatically fill in missing days. This is an important step for diff-ing 


----------------------------------------------------------------------
- Double check how different are the testing criteria across all Canadian provinces.

- Is the time stamp in README.md automated? (Could use README.rmd for this ...) Do we need separate front ends/READMEs for the GH pages version ("end-user") and the repo version ("developer")?  (I had to guess to `make plot.png` to generate `plot.wrapR.r`. Or do we not think that anyone else will want to mess with the repo-level machinery?)

- consider colorspace + `scale_colour_discrete_qualitative()` ?

