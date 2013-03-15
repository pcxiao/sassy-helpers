#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "run treetop"
task :treetop do
	`tt lib/modelling/parser/sassyparser.treetop`
end

### Task: rdoc
# require 'rake/rdoctask'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
	rdoc.title    = "SASSy-Helpers Conversion Scripts"
	rdoc.rdoc_dir = 'doc'

	rdoc.options += [
	    '-w', '4',
	    '-SHN',
	    '-f', 'darkfish', # This bit
	    '-m', 'README.md',
	  ]

	rdoc.rdoc_files.include 'README.md'
	rdoc.rdoc_files.include 'lib/*.rb'
	rdoc.rdoc_files.include 'lib/modelling/*.rb'
end