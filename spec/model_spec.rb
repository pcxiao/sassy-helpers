# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Model do
  it "can create a model" do
	m = Modelling::Model::new
	m.name.should eql("Model")
  end

  it 'can merge models' do
	m1 = Modelling::Model::new("Model1")
	m2 = Modelling::Model::new("Model2")

	m1.combine_with(m2)

	m1.name.should eql("Model1 & Model2")
  end

end