
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'sandbox/cli'

describe Sandbox::CLI do
  
  it "should raise an error when running from a loaded sandbox" do
    begin
      ENV[ 'SANDBOX' ] = 'something'
      lambda { Sandbox::CLI.verify_environment! }.should raise_error( Sandbox::LoadedSandboxError )
    ensure
      ENV[ 'SANDBOX' ] = nil
    end
  end
  
  describe "calling execute" do
    
    before( :each ) do
      @instance = stub_everything()
    end
    
    it "should handle all errors" do
      Sandbox::CLI.stubs( :new ).raises( StandardError )
      Sandbox::CLI.expects( :handle_error ).with( instance_of( StandardError ) )
      Sandbox::CLI.execute
    end
    
    it "should attempt to parse ARGV by default" do
      Sandbox::CLI.expects( :parse ).with( ARGV ).returns( @instance )
      Sandbox::CLI.execute
    end
    
    it "should create a new instance" do
      Sandbox::CLI.expects( :new ).returns( @instance )
      Sandbox::CLI.execute
    end
    
    it "should call parse_args! on the new instance" do
      @instance.expects( :parse_args! )
      Sandbox::CLI.expects( :new ).returns( @instance )
      Sandbox::CLI.execute
    end
    
    it "should run the instance" do
      @instance.expects( :execute! )
      Sandbox::CLI.expects( :parse ).returns( @instance )
      Sandbox::CLI.execute
    end
    
  end
  
  describe "a new instance" do
    
    before( :each ) do
      @cli = Sandbox::CLI.new
    end
    
    it "should have default 'gems to install'" do
      @cli.options[ :gems ] = [ 'rake' ]
    end
    
    describe "instance calling parse_args!" do
      
      def processor( *args ); lambda { @cli.parse_args!( args ) }; end
      def process( *args ); processor( *args ).call; end
  
      describe "using NO arguments" do
  
        it "should use raise nothing" do
          process()
          @cli.options[ :original_args ].should == []
          @cli.options[ :args ].should == []
        end
  
      end
  
      describe "using VALID arguments" do
  
        [ '-V', '--version' ].each do |arg|
          it "should print the version for switch '#{arg}'" do
            @cli.expects( :puts ).with( Sandbox::Version::STRING )
            processor( arg ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
          end
        end
          
        [ '-V', '--version' ].each do |arg|
          it "should ignore additional arguments after '#{arg}'" do
            # @cli.stubs(:puts)
            @cli.expects( :puts ).with( Sandbox::Version::STRING ).times(2)
            processor( arg, '-x' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
            processor( arg, 'unknown' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
          end
        end
          
        [ '-h', '--help' ].each do |arg|
          it "should show help for '#{arg}'" do
            @cli.expects( :puts ).with( instance_of( OptionParser ) )
            processor( arg ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
          end
        end
          
        [ '-h', '--help' ].each do |arg|
          it "should ignore additional arguments after '#{arg}'" do
            @cli.expects( :puts ).with( instance_of( OptionParser ) ).times(2)
            processor( arg, '-x' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
            processor( arg, 'unknown' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
          end
        end
        
        [ '-H', '--long-help' ].each do |arg|
          it "should show long help for '#{arg}'" do
            @cli.expects( :puts )
            @cli.expects( :long_help )
            processor( arg ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
          end
        end
          
        [ '-v', '--verbose' ].each do |arg|
          it "should increase verbosity with '#{arg}'" do
            Sandbox.expects( :increase_verbosity )
            process( arg )
            @cli.options[ :original_args ].should == [ arg ]
            @cli.options[ :args ].should == []
          end
        end
        
        [ [ '-v', '-v' ], [ '--verbose', '--verbose' ] ].each do |args|
          it "should increase verbosity twice with '#{args.join(' ')}'" do
            Sandbox.expects( :increase_verbosity ).times(2)
            process( *args )
            @cli.options[ :original_args ].should == args
            @cli.options[ :args ].should == []
          end
        end
        
        it "should require additional arguments with switch '-g'" do
          processor( '-g' ).should raise_error( Sandbox::ParseError )
        end
        
        it "should set 'gems to install' with switch '-g'" do
          args = [ '-g', 'somegem,anothergem' ]
          process( *args )
          @cli.options[ :original_args ].should == args
          @cli.options[ :args ].should == []
          @cli.options[ :gems ].should == [ 'somegem', 'anothergem' ]
        end
        
        it "should clear 'gems to install' with switch '-n'" do
          process( '-n' )
          @cli.options[ :original_args ].should == [ '-n' ]
          @cli.options[ :args ].should == []
          @cli.options[ :gems ].should == []
        end
        
        it "should store leftover arguments in options for arguments '/path/to/somewhere'" do
          args = [ '/path/to/somewhere' ]
          process( *args )
          @cli.options[ :original_args ].should == args
          @cli.options[ :args ].should == args
        end
        
        it "should store leftover arguments in options for arguments '-v /path/to/somewhere'" do
          args = [ '-v', '/path/to/somewhere' ]
          process( *args )
          @cli.options[ :original_args ].should == args
          @cli.options[ :args ].should == [ args.last ]
        end
      end
  
      describe "using INVALID arguments" do
        
        it "should exit with message for invalid switch '-x'" do
          processor( '-x' ).
              should raise_error( Sandbox::ParseError ) { |error| error.message.should =~ /-x\b/ }
        end
        
      end
  
    end
    
    describe "instance calling execute!" do
      
      def processor; lambda { @cli.execute! }; end
      def process; processor.call; end
      
      it "should raise error with no target specified" do
        @cli.options[ :args ] = []
        processor.should raise_error
      end
      
      it "should raise error with more than one target" do
        @cli.options[ :args ] = [ 'one', 'two' ]
        processor.should raise_error
      end
      
      it "should instantiate an Installer and call populate with one target" do
        @cli.options.delete( :gems )
        @cli.options[ :args ] = [ 'one' ]
        installer = mock( 'Installer', :populate )
        Sandbox::Installer.expects( :new ).with( { :target => 'one' } ).returns( installer )
        process
      end
      
    end
    
  end
  
end

