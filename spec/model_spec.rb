# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Model do
  it "can create a model" do
	m = Modelling::Model::new
	m.name.should eql("Model")
  end

end