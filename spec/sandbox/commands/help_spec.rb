
require File.dirname( __FILE__ ) + '/../../spec_helper'
require 'sandbox/commands/help'


describe Sandbox::Commands::HelpCommand do
  
  # it "should set it's name and description when calling 'new'" do
  #   
  #   Sandbox::Commands::HelpCommand.new
  # end
  
end

describe Sandbox::Commands::HelpCommand, 'instance' do
  
  before( :each ) do
    @cmd = Sandbox::Commands::HelpCommand.new
  end
  
  it "should set it's name and summary when calling 'new'" do
    @cmd.name.should == 'help'
    @cmd.summary.should =~ /Provide help on/
  end
  
  it "should show application default help message with no arguments" do
    @cmd.expects( :show_application_help )
    @cmd.run( [] )
  end
  
  it "should show help's help message with '-h'" do
    @cmd.expects( :show_help )
    @cmd.run( ['-h'] )
  end
  
  it "should list the commands and their summaries via CommandManager" do
    help_cmd = mock( 'HelpCommand', :name => 'help', :summary => 'help summary' )
    init_cmd = mock( 'InitCommand', :name => 'init', :summary => 'init summary' )
    Sandbox::CommandManager.expects( :command_names ).returns( [ 'help', 'init' ] )
    Sandbox::CommandManager.expects( :[] ).with( 'help' ).returns( help_cmd )
    Sandbox::CommandManager.expects( :[] ).with( 'init' ).returns( init_cmd )
    @cmd.run( ['commands'] )
  end
  
  it "should respond to command 'dummy'" do
    dummy = mock( 'DummyCommand' )
    dummy.expects( :run ).with( ['--help'] )
    Sandbox::CommandManager.expects( :command_names ).returns( [ 'dummy' ] )
    Sandbox::CommandManager.expects( :[] ).with( 'dummy' ).returns( dummy )
    @cmd.run( ['dummy'] )
  end
  
end
