
require File.dirname( __FILE__ ) + '/../../spec_helper'
require 'sandbox/commands/init'


describe Sandbox::Commands::InitCommand do
  
  # it "should set it's name when calling 'new'" do
  #   Sandbox::Command.expects( :initialize ).with( 'init' )
  #   
  #   Sandbox::Commands::InitCommand.new
  # end
  
end

describe Sandbox::Commands::InitCommand, 'instance' do
  
  before( :each ) do
    @cmd = Sandbox::Commands::InitCommand.new
  end
  
  it "should set it's name and summary when calling 'new'" do
    @cmd.name.should == 'init'
    @cmd.summary.should =~ /Create a new sandbox/
  end
  
  it "should set default options" do
    @cmd.options[ :ruby_install ].should be_false
    @cmd.options[ :rubygems_install ].should be_false
    @cmd.options[ :dryrun ].should be_false
  end
  
  describe "when process_options! called" do
    
    it "should not process target path"
    
  end
  
  describe "when execute! called" do
    
    it "should fail with more than one argument left over"
    it "should fail without target path provided"
    it "should fail when base path up to target does not exist"
    it "should create all directories when create_all_directories option is set"
    
  end
  
  it "should load configuration"
  it "should merge loaded configuration with defaults or options???" 
  it "should download ruby"
  it "should look in cache for it first"
  it "should download rubygems"
  it "should look in cache for it first"
  it "should unpackage downloads"
  it "should look in cache for it first"
  it "should create sandbox directory structure"
  it "should build products into sandbox"
  it "should setup needed scripts in WORKSPACE/bin"
  it "should validate target directory"
  it "should symlink gem command"
  it "should handle install of additional gems"
  it "should cache downloads in userdir?"
  
  # init:
  #   get ruby version to install
  #   get cache location
  #   get target location
  #   create target location
  #     bin, etc, lib, rubygems
  #   change to tmp dir
  #   create new Lookup to get download url for ruby
  #   create new Downloader for ruby tarball and store in cache
  #   create new Extractor for ruby tarball and extract to tmp
  #   change to ruby directory
  #   create new Builder for ruby
  #     configure --prefix target
  #     make
  #     make install
  #   change to tmp dir
  #   clean up ruby dir?
  #   
  #   
  #   same for rubygems
  #     backup users .gemrc file
  #     add symlink to gem executable
  #   
  #   read in activate template
  #   write out activate script to target/bin
    
end
