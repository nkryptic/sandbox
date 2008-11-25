
require File.dirname( __FILE__ ) + '/../../spec_helper'
require 'workspace/commands/help_command'


describe Workspace::Commands::HelpCommand do
  
  # it "should set it's name when calling 'new'" do
  #   Workspace::Command.expects( :initialize ).with( 'help' )
  #   
  #   Workspace::Commands::HelpCommand.new
  # end
  
end

describe Workspace::Commands::HelpCommand, 'instance' do
  
  before( :each ) do
    @cmd = Workspace::Commands::HelpCommand.new
  end
  
  it "should have a description"
  
end
