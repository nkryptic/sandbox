
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
    
    it "should not process target path" do
      args = [ '/path/to/new/sandbox' ]
      @cmd.process_options!( args )
      @cmd.options[ :args ].should == args
    end
    
  end
  
  describe "when execute! called" do
    
    before( :all ) do
      @abs_dir = '/path/to/new'
      @abs_target = @abs_dir + '/target'
      @rel_target = 'target'
      @deep_rel_dir = 'path/to/new'
      @deep_rel_target = @deep_rel_dir + 'target'
    end
    
    it "should show it's help when no args passed" do
      @cmd.options[ :args ] = []
      @cmd.expects( :show_help )
      @cmd.execute!
    end
    
    it "should fail with more than one argument left over" do
      @cmd.options[ :args ] = [ '/path/to/new/sandbox', '/path/to/new/sandbox2' ]
      @cmd.expects( :raise )
      @cmd.execute!
    end
    
    # it "should raise error when get_target returns nil" do
    #   @cmd.options[ :args ] = [ @abs_target ]
    #   @cmd.expects( :get_target ).with( @abs_target ).returns( nil )
    #   lambda { @cmd.execute! }.should raise_error( Sandbox::SandboxError ) { |error| error.message.should =~ /target directory exists/ }
    # end
    
    # it "should expand path from current directory with non-absolute target" do
    #   File.expects( :exists? ).with( @rel_target ).returns( false )
    #   FileUtils.expects( :pwd ).returns( @abs_dir )
    #   FileUtils.expects( :mkdir_p ).with( @abs_target )
    #   @cmd.options[ :args ] = [ @rel_target ]
    #   @cmd.execute!
    # end
    # 
    # it "should fail when target exists" do
    #   # File.expects( :directory? ).with( dirpath ).returns( true )
    #   File.expects( :exists? ).with( @abs_target ).returns( true )
    #   @cmd.options[ :args ] = [ @abs_target ]
    #   @cmd.expects( :raise )
    #   @cmd.execute!
    # end
    
    # it "should fail when base path up target is not writable"
    
    it "should create all directories for target as needed"
    
  end
  
  describe "when get_target called" do
    
    it "should fail when base path up target is not writable"
    
  end
  
  
  it "should fail when not writable"
  it "should expand path on relative target"
  it "should create directory $HOME/.sandbox"
  it "should create directory for target"
  it "should create entire path for target"
  it "should not create target until it is needed"
  
  
  # it "should load configuration"
  # it "should merge loaded configuration with defaults or options???" 
  # it "should download ruby"
  # it "should look in cache for it first"
  # it "should download rubygems"
  # it "should look in cache for it first"
  # it "should unpackage downloads"
  # it "should look in cache for it first"
  # it "should create sandbox directory structure"
  # it "should build products into sandbox"
  # it "should setup needed scripts in SANDBOX/bin"
  # it "should validate target directory"
  # it "should symlink gem command"
  # it "should handle install of additional gems"
  # it "should cache downloads in userdir?"
  
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
