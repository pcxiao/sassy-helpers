# -*- encoding: utf-8 -*-
require "treetop"
require "sassy-helpers"
require "modelling/sassyparser"

describe Modelling::SassyParser do
	def test_parse(str, sym)
		parser = Modelling::SassyParser.new
		q = parser.parse(str, :root => sym)
		if !q
		  puts parser.failure_reason
		  puts parser.failure_line
		  puts parser.failure_column
		end
		q.should_not eql(nil)
		q
	end

	it 'parses idents' do 
		test_parse('a', :ident).text_value.should eql('a')
		test_parse('a123', :ident).text_value.should eql('a123')
		test_parse('a_123', :ident).text_value.should eql('a_123')
	end

	it 'parses comments' do 
		test_parse('% a test ', :comment).value.should eql('a test')
		test_parse('... a test ', :comment).value.should eql('a test')
	end

	it 'parses ident lists' do 
		test_parse('[]', :identlist).value.should eql([])
		test_parse('[a,b,c]', :identlist).value.should eql(['a', 'b', 'c'])
		test_parse('[ a,b ,c ]', :identlist).value.should eql(['a', 'b', 'c'])
		test_parse('[ac]', :identlist).value.should eql(['ac'])
		test_parse('ac', :identlist).value.should eql(['ac'])
	end

	it 'parses ident tuples' do 
		test_parse('()', :identtuple).value.should eql([ ])
		test_parse('(ac)', :identtuple).value.should eql(['ac'])
		test_parse('(a,b,c)', :identtuple).value.should eql(['a', 'b', 'c'])
		test_parse('(a, bbb,c )', :identtuple).value.should eql(['a', 'bbb', 'c'])
		test_parse('( a , b,c)', :identtuple).value.should eql(['a', 'b', 'c'])
	end

	it 'parses function defs' do 
		test_parse("function x = f(a, b)", :function).value.should eql({
			:name => 'f',
			:returns => [ 'x' ],
			:parameters => [ 'a', 'b' ],
			})

		test_parse("function [x1, x2] = ffasf_1()", :function).value.should eql({
			:name => 'ffasf_1',
			:returns => [ 'x1', 'x2' ],
			:parameters => [ ],
			})
	end
	it 'parses sassy files' do 
		test_parse(File.read("spec/herzel_model.m"), :root).value.should_not eql(nil)
	end
end