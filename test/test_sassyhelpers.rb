require 'test/unit'
require 'sassy-helpers'

class SassyTest < Test::Unit::TestCase
	def test_create_model
		puts "Creating a new model \n"
		m = Model::new
		assert m.name == "Model"
	end
end