# Sassy Modelling Helpers Gem

This is a set of Ruby scripts for creating ODE models that
can be used in [SASSy](http://www2.warwick.ac.uk/fac/sci/systemsbiology/research/software/), 
a [MATLAB](http://mathworks.co.uk)-based software for performing
sensitivity analysis on [dynamical systems models](http://en.wikipedia.org/wiki/Dynamical_systems), e.g. in [mathematical biology](http://en.wikipedia.org/wiki/Mathematical_and_theoretical_biology). Especially together with converters like [VFGen](http://www.warrenweckesser.net/vfgen/) and [SBFC](http://www.ebi.ac.uk/compneur-srv/converters/converters), this tool is helpful when creating command-line scripted parameter sweeps or when using different software packages for analysing a model.

So far, it can:

* Read models from [XPP format](http://mrb.niddk.nih.gov/xpp/newstyle.html) used e.g. in [XPP-Auto](http://www.math.pitt.edu/~bard/xpp/xpp.html)
* Read models and parameter files in SASSy's own format
* Write these models to MATLAB/SASSy/XPP/SBML/VFGen/C++ format
* Merge two models into one by re-defining parameters as species (this requires writing a Ruby script)
* Change parameters in a model on the command line for quick scripted parameter sweeps.
* Replace parameters by their numerical values (useful when using together with [VFGen](http://www.warrenweckesser.net/vfgen/) to output [Auto](http://indy.cs.concordia.ca/auto/) models).

## Installation

### Quick install

While this is in gem format and uses [Bundler](http://gembundler.com/), 
I have not uploaded it to something like [Rubygems](rubygems.org) yet.

Therefore, the simplest way to use it might well be to clone the 
repository to your computer, and install the dependencies like this:

```
$ git clone https://github.com/pkrusche/sassy-helpers.git
# ...
$ cd sassy-helpers
$ bundle install
# ...
```

To see if everything works ok, you can run

```
bundle exec rspec
```

to run the tests. Some example models are included in `spec/testmodels`.

You can then install the gem by running

```
rake install
```

### Should this not work...

You need to have Ruby at version > 1.9.3 and a relatively recent version of 
bundler. On OSX 10.6 (like my system), this isn't necessarily the case by default.

The easiest way to get these is using [RVM](https://rvm.io/).

In short, run something like

```
\curl -L https://get.rvm.io | bash -s stable --ruby
rvm install 1.9.3
rvm use 1.9.3
gem install bundler

# ... go to the sassy-helpers directory

# this installs dependencies
bundle install
```

Again, you can install the gem by running

```
rake install
```

## Usage

In the sassy-helpers directory, there is a `bin` directory, which contains the
`sassyconvert` script.

**WARNING**: This script will not ask to overwrite outputs if they already exist,
but rather just go and do so. Make backups of your ode and model files (or write 
to a different location).

You can use it to convert back and forth between different formats:

```
$ bin/sassyconvert spec/testmodels/ode/cellcycle_gerard10_5var.ode cellcycle_gerard10_5var
```

will create three files:

```
cellcycle_gerard10_5var_model.m
cellcycle_gerard10_5var.par
cellcycle_gerard10_5var.y
```

You can also convert these back to ode:

```
$ sassyconvert cellcycle_gerard10_5var cellcycle.ode --informat sassy --outformat xpp
```

This will create `cellcycle.ode`. Note that this file is not necessarily identical with
the original ode file it came from: the xpp format has a few fuzzy rules, and we don't
remember the exact way this was implemented in the input file (we do remember extra
lines with an @ or " in the beginning though).

It is possible to change parameter values in the output model, the following sets the parameter GF to 2 (note: no spaces allowed in the assignment statement -- `GF = 2` rather than `GF=2` will give an error).

```
$ sassyconvert cellcycle_gerard10_5var cellcycle.ode --informat sassy --outformat xpp --set GF=2.0
```

Running the script with option `--help` will show further options.

## Limitations

Note that due to the limitations of what SASSy can do, we are 
limited to a subset of XPP's (and eventually SBML's) features: 

* Models can only have scalar or rate rules
* No SBML-style reactions are supported
* Formulas must be in MATLAB/Octave-friendly format
* Not all of XPP's features are supported (boundary conditions, int{...}, etc.)

Some sanity-checking is done on the models, but we don't actually
parse formulas (match braces, check for existence of functions, etc.).

When things aren't recognized, you can see warnings like

```
[W] unmatched xpp line: f(u)=1/(1+exp(-( )))
```
and then possibly the model won't validate.

## TODOs

... stuff I plan to add

* VFGen XML format input
