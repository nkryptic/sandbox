
require File.dirname( __FILE__ ) + '/../../spec_helper'
require 'sandbox/commands/init'


# describe Sandbox::Commands::InitCommand do
#   it "should be magic" do
#     Sandbox::Commands::InitCommand.new
#   end
# end

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
  
  describe "when run is called" do
    
    it "should load configuration because it sets uses_config" do
      @cmd.stubs( :process_options! )
      Sandbox.expects( :load_config )
      @cmd.stubs( :execute! )
      @cmd.run( [] )
    end
    
  end
  
  describe "when process_options! called" do
    
    it "should not process target path" do
      args = [ '/path/to/new/sandbox' ]
      @cmd.process_options!( args )
      @cmd.options[ :args ].should == args
    end
    
  end
  
  describe "when execute! called" do
    
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
    
    it "should create Installer with target and run it" do
      target = '/path/to/new/sandbox'
      installer = mock( "Installer" )
      installer.expects( :populate )
      @cmd.options[ :args ] = [ target ]
      # @cmd.stubs( :resolve_target ).returns( target )
      Sandbox::Installer.expects( :new ).with( target ).returns( installer )
      @cmd.execute!
    end
    
  end
    
    # it "should create directory for target"
    # it "should create entire path for target"
    # it "should not create target until it is needed"

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
