
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
  
  it "should set it's name and summary when calling 'new'" do
    @cmd.name.should == 'init'
    @cmd.summary.should =~ /Create a new workspace/
  end
  
  it "should have a description"
  it "should set install type"
  it "should load configuration"
  it "should download ruby"
  it "should download rubygems"
  it "should unpackage download"
  it "should build into workspace"
  it "should setup needed scripts in WORKSPACE/bin"
  it "should validate target directory"
  it "should symlink gem command"
  it "should cache downloads in userdir?"
  
end
