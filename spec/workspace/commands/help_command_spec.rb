
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
  
  it "should show application default help message with no arguments" do
    @cmd.expects( :show_application_help )
    @cmd.run( [] )
  end
  
  # it "should list the commands and their summaries via CommandManager" do
  #   Workspace::CommandManager.expects( :command_names )
  #   @cmd.run( ['commands'] )
  # end
  
  it "should respond to command 'dummy'"
  it "should show possible arguments"
  
end
