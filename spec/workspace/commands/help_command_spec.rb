
require File.dirname( __FILE__ ) + '/../../spec_helper'
require 'workspace/commands/help_command'


describe Workspace::Commands::HelpCommand do
  
  # it "should set it's name and description when calling 'new'" do
  #   
  #   Workspace::Commands::HelpCommand.new
  # end
  
end

describe Workspace::Commands::HelpCommand, 'instance' do
  
  before( :each ) do
    @cmd = Workspace::Commands::HelpCommand.new
  end
  
  it "should set it's name and summary when calling 'new'" do
    @cmd.name.should == 'help'
    @cmd.summary.should =~ /Provide help on/
  end
  
  it "should respond to 'commands'"
  it "should respond to command 'dummy'"
  it "should show possible arguments"
  
end
