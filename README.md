# Sassy Modelling Helpers Gem

This is a set of Ruby scripts for creating ODE models that
can be used in [SASSy](http://www2.warwick.ac.uk/fac/sci/systemsbiology/research/software/), 
a [MATLAB](http://mathworks.co.uk)-based software for performing
sensitivity analysis on [dynamical systems models](http://en.wikipedia.org/wiki/Dynamical_systems), e.g. in [mathematical biology](http://en.wikipedia.org/wiki/Mathematical_and_theoretical_biology).

So far, we can 

* create models in Ruby
* read models from [XPP format](http://mrb.niddk.nih.gov/xpp/newstyle.html) used e.g. in [XPP-Aut](http://www.math.pitt.edu/~bard/xpp/xpp.html)
* Read models and parameter files in SASSy's own format
* write these models to MATLAB/SASSy/XPP/SBML format
* Merge two models into one by re-defining parameters as species

## Installation

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

It needs to have Ruby at version > 1.9.3 and a relatively recent version of 
bundler. The easiest way to get these is using [RVM](https://rvm.io/).

In short, run

```
\curl -L https://get.rvm.io | bash -s stable --ruby
rvm install 1.9.3
rvm use 1.9.3
gem install bundler

# ... go to the sassy-helpers directory

# this installs dependencies
bundle install

```

Hopefully, I will find the time to make this all easier soon.

## Usage

In the sassy-helpers directory, there is a `bin` directory, which contains the
`sassyconvert` script.

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

Running the script with option `--help` will show further options.

## Limitations

Note that due to the limitations of what SASSy can do, we are 
limited to a subset of XPP's and SBML's features: 

* Models can only have scalar or rate rules
* No SBML-style reactions are supported
* Formulas must be in MATLAB/Octave-friendly format

Some sanity-checking is done on the models, but we don't actually
parse formulas (match braces, check for existence of functions, etc.).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
