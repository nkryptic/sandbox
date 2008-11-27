
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'sandbox/command'


describe Sandbox::Command do
  
  it "should have common options" do
    copts = Sandbox::Command.common_parser_opts
    copts.detect { |opt| opt.first.include?( '-h' ) }.should_not be_nil
    copts.detect { |opt| opt.first.include?( '--help' ) }.should_not be_nil
    copts.detect { |opt| opt.first.include?( '-v' ) }.should_not be_nil
    copts.detect { |opt| opt.first.include?( '--verbose' ) }.should_not be_nil
    copts.detect { |opt| opt.first.include?( '-q' ) }.should_not be_nil
    copts.detect { |opt| opt.first.include?( '--quiet' ) }.should_not be_nil
  end
  
  it "should require a name when calling 'new'" do
    cmd = nil
    lambda { Sandbox::Command.new }.
        should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
    lambda { cmd = Sandbox::Command.new( 'name' ) }.should_not raise_error()
    cmd.name.should == 'name'
  end
  
  it "takes an optional summary on creation" do
    cmd = nil
    lambda { cmd = Sandbox::Command.new( 'name', 'I command' ) }.should_not raise_error()
    cmd.summary.should == 'I command'
  end
  
  it "takes a hash as it's defaults and options on creation" do
    cmd = nil
    opts = { :something => true, :someone => :me }
    lambda { cmd = Sandbox::Command.new( 'name', 'I command', opts ) }.should_not raise_error()
    cmd.defaults[ :something ].should be_true
    cmd.options[ :someone ].should == :me
  end
  
end

describe Sandbox::Command, 'instance' do
  
  before( :each ) do
    @cmd = Sandbox::Command.new( 'dummy', 'dummy summary' )
  end
  
  it "should raise NotImplementedError on execute!" do
    lambda { @cmd.execute! }.
        should raise_error( NotImplementedError ) { |error| error.message.should =~ /must be implemented/ }
  end
  
  it "should have a command string" do
    @cmd.cli_string.should == "sandbox dummy"
  end
  
  it "should have an empty description" do
    @cmd.description.should be_nil
  end
  
  it "should have a default usage" do
    @cmd.usage.should == @cmd.cli_string
  end
  
  it "should build a parser only when needed" do
    opts = mock()
    OptionParser.expects( :new ).once.then.returns( opts )
    @cmd.instance_eval { @parser }.should be_nil
    @cmd.parser
    @cmd.instance_eval { @parser }.should == opts
    @cmd.parser.should == opts
  end
  
  it "should add common switches to parser" do
    Sandbox::Command.expects( :common_parser_opts )
    @cmd.parser
  end
  
  it "should add local switches to parser" do
    @cmd.expects( :parser_opts )
    @cmd.parser
  end
  
  it "should provide a default help message using usage" do
    io = capture do
      @cmd.show_help
    end
    io.stdout.should =~ /^Usage: #{@cmd.usage}/
  end
  
  describe "calling run" do
    
    def processor( *args ); lambda { @cmd.run( *args ) }; end
    def process( *args ); processor( *args ).call; end
    
    it "should require array of arguements" do
      @cmd.stubs( :execute! )
      processor().should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
      processor( [] ).should_not raise_error()
      processor( [], true ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
      processor( [], { :x => true } ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
    end
    
    [ '-h', '--help' ].each do |arg|
      it "should call show_help for option '#{arg}'" do
        @cmd.expects( :show_help )
        process( [arg] )
      end
    end
    
    it "should display error on bad option" do
      processor( [ '-x' ] ).
          should raise_error( Sandbox::SandboxError ) { |error| error.message.should =~ /^invalid option: -x/ }
    end
    
  end
  
  describe "calling process_options!" do
    
    def processor( *args ); lambda { @cmd.process_options!( *args ) }; end
    def process( *args ); processor( *args ).call; end
    
    it "should require array of arguments" do
      processor().should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
      processor( [] ).should_not raise_error( ArgumentError )
      processor( [], true ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
      processor( [], { :x => true } ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
    end
    
    describe "with valid arguments" do
      
      [ '-h', '--help' ].each do |arg|
        it "should set help option for argument '#{arg}'" do
          process( [arg] )
          @cmd.options[ :help ].should be_true
        end
      end
      
      [ '-v', '--verbose' ].each do |arg|
        it "should set verbosity option properly for argument '#{arg}'" do
          process( [arg] )
          @cmd.options[ :verbosity ].should == 1
        end
      end
      
      it "should set verbosity option properly for argument '-vv'" do
        process( ['-vv'] )
        @cmd.options[ :verbosity ].should == 2
      end
      
      [ '-q', '--quiet' ].each do |arg|
        it "should set verbosity option properly for argument '#{arg}'" do
          process( [arg] )
          @cmd.options[ :verbosity ].should == -1
        end
      end
      
      it "should set verbosity option properly for argument '-qq'" do
        process( ['-qq'] )
        @cmd.options[ :verbosity ].should == -2
      end
      
      it "should save non-switch args into options" do
        args = [ '-v', '/path/to/somewhere' ]
        process( args )
        @cmd.options[ :args ].should == args
      end
      
    end
    
  end
  
end
