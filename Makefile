current: target
-include target.mk

-include makestuff/perl.def

Drop = ~/Dropbox

######################################################################


Sources += $(wildcard *.R)
Ignore += $(wildcard *.csv)

clean.Rout.csv: clean.R
clean.Rout: clean.R
	$(run-R)

plot.Rout: clean.Rout plot.R
	$(run-R)

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
