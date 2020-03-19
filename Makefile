current: target
-include target.mk

-include makestuff/perl.def

Drop = ~/Dropbox

######################################################################

## https://wzmli.github.io/COVID19-Canada/ 
## pages are on master branch

Sources += $(wildcard *.R)

Sources += clean.Rout.csv
clean.Rout.csv: clean.R
## Warning: redundant specification
clean.Rout: COVID-19_test.csv clean.R
	$(run-R)

plot.png: plot.Rout ;
plot.Rout: clean.Rout plot.R
	$(run-R)

Sources += README.md plot.png

README.gh.html: README.md

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

-include makestuff/wrapR.mk
## -include makestuff/pandoc.mk

-include makestuff/git.mk
-include makestuff/texdeps.mk
-include makestuff/visual.mk
-include makestuff/hotcold.mk
-include makestuff/cihrpaste.mk
-include makestuff/pandoc.mk
-include makestuff/projdir.mk
