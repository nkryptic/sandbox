
require File.dirname( __FILE__ ) + '/spec_helper.rb'

describe Sandbox do
  
  before( :each ) do
    Sandbox.instance_eval { instance_variables.each { |v| remove_instance_variable v } }
  end
  
  it "should have verbosity level" do
    Sandbox.verbosity.should == 0
  end
  
  it "should increase verbosity level" do
    Sandbox.verbosity.should == 0
    Sandbox.increase_verbosity
    Sandbox.verbosity.should == 1
  end
  
  it "should decrease verbosity level" do
    Sandbox.verbosity.should == 0
    Sandbox.decrease_verbosity
    Sandbox.verbosity.should == -1
  end
  
end

