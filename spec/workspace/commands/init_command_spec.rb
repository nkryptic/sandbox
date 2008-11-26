
require File.dirname( __FILE__ ) + '/../../spec_helper'
require 'workspace/commands/init_command'


describe Workspace::Commands::InitCommand do
  
  # it "should set it's name when calling 'new'" do
  #   Workspace::Command.expects( :initialize ).with( 'init' )
  #   
  #   Workspace::Commands::InitCommand.new
  # end
  
end

describe Workspace::Commands::InitCommand, 'instance' do
  
  before( :each ) do
    @cmd = Workspace::Commands::InitCommand.new
  end
  
  it "should have a description"
  
end
