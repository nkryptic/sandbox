
require File.dirname( __FILE__ ) + '/../spec_helper.rb'

describe Sandbox::Config do
  
  before( :each ) do
    Sandbox::Config.instance_eval { instance_variables.each { |v| remove_instance_variable v } }
  end
  
  describe "creating instance" do
    
    it "should set config file to default" do
      uh = '/home/me'
      Sandbox::Config.stubs( :find_user_home ).returns( uh )
      @config = Sandbox::Config.new
      @config.config_file.should == uh + '/.sandbox/config'
    end
    
    it "should set config directory to default" do
      uh = '/home/me'
      Sandbox::Config.stubs( :find_user_home ).returns( uh )
      @config = Sandbox::Config.new
      @config.directory.should == uh + '/.sandbox'
    end
    
    describe "with config file passed in" do
      
      it "should set config file to what is passed in" do
        cf = '/path/to/another/config/file'
        @config = Sandbox::Config.new( :config_file => cf )
        @config.config_file.should == cf
      end
      
      it "should set config directory to default" do
        cf = '/path/to/another/config/file'
        uh = '/home/me'
        Sandbox::Config.stubs( :find_user_home ).returns( uh )
        @config = Sandbox::Config.new( :config_file => cf )
        @config.directory.should == uh + '/.sandbox'
      end
      
      it "should set config directory to what is stated in config file" do
        cf = '/path/to/another/config/file'
        base_dir = '/path/to/some/directory'
        Sandbox::Config.any_instance.stubs( :load_file ).with( cf ).returns( { :directory => base_dir } )
        @config = Sandbox::Config.new( :config_file => cf )
        @config.directory.should == base_dir
      end
      
    end
    
  end
  
  describe "a new instance" do
    
    before( :each ) do
      @config = Sandbox::Config.new
    end
    
    it "should set default install type" do
      @config.install_type.should == :virtual
    end
    
    it "should set default ruby version" do
      @config.ruby_to_install.should == 'ruby-1.8.6-p287'
    end
    
    it "should set default rubygems version" do
      @config.rubygems_to_install.should == 'rubygems-1.3.1'
    end
    
  end
  
end

