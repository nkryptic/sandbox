require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/cli'

describe Workspace::CLI do
  
  describe "calling execute" do
    
    before( :each ) do
      @instance = stub_everything()
    end
    
    it "should attempt to parse ARGV" do
      Workspace::CLI.expects( :parse ).with( ARGV ).returns( @instance )
      
      Workspace::CLI.execute
    end
    
    it "should create a new instance" do
      Workspace::CLI.expects( :new ).returns( @instance )
      
      Workspace::CLI.execute
    end
    
    it "should call parse_options! on the new instance" do
      @instance.expects( :parse_options! )
      Workspace::CLI.expects( :new ).returns( @instance )
      
      Workspace::CLI.execute
    end
    
    it "should run the instance" do
      @instance.expects( :execute! )
      Workspace::CLI.expects( :parse ).returns( @instance )
      
      Workspace::CLI.execute
    end
    
  end
  
  describe "instance calling parse_options!" do
    
    before( :each ) do
      @cli = Workspace::CLI.new
    end

    def processor( *args )
      lambda { @cli.parse_options!( args ) }
    end

    def process( *args )
      processor( *args ).call
    end
    
    describe "using NO arguments" do
      
      it "should use help command" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( [] )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )

        process()
      end
      
    end
    
    describe "using VALID arguments" do

      [ '-v', '--version' ].each do |arg|
        it "should print the version for switch '#{arg}'" do
          @cli.expects(:puts).with( "workspace v#{Workspace::Version::STRING}" )

          processor( arg ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
        end
      end

      [ '-v', '--version' ].each do |arg|
        it "should ignore additional arguments after '#{arg}'" do
          @cli.expects(:puts).with( "workspace v#{Workspace::Version::STRING}" )

          processor( arg, '-x' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
        end
      end
      
      [ '-d', '--debug' ].each do |arg|
        it "should set instance's debug option to true for switch '#{arg}'" do
          @cli.expects( :find_command )
          
          process( arg )
          @cli.options[ :debug ].should be_true
        end
      end

      [ '-d', '--debug' ].each do |arg|
        it "should not ignore additional arguments after '#{arg}'" do
          cmd = mock( 'DummyCommand' )
          cmd.expects( :process_options! ).with( ['-z'] )
          @cli.expects( :find_command ).with( 'dummy' ).returns( cmd )
          @cli.expects( :commands ).returns( ['dummy'] )

          process( arg, 'dummy', '-z' )
          @cli.options[ :debug ].should be_true
        end
      end

      [ '-h', '--help', nil ].each do |arg|
        it "should use help command for switch '#{arg}'" do
          cmd = mock( 'HelpCommand' )
          cmd.expects( :process_options! ).with( [] )
          @cli.expects( :find_command ).with( 'help' ).returns( cmd )

          process( arg ) 
        end
      end

      [ '-h', '--help' ].each do |arg|
        it "should ignore additional arguments after '#{arg}'" do
          cmd = mock( 'HelpCommand' )
          cmd.expects( :process_options! ).with( [] )
          @cli.expects( :find_command ).with( 'help' ).returns( cmd )

          process( arg, '-x' )
        end
      end

      it "should use help command for argument 'help'" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( [] )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )
        @cli.expects( :commands ).returns( ['help'] )

        process( 'help' ) 
      end

      it "should use help command for arguments 'help dummy'" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( ['dummy'] )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )
        @cli.expects( :commands ).returns( ['help'] )

        process( 'help', 'dummy' )
      end

      it "should use dummy command for argument 'dummy'" do
        cmd = mock( 'DummyCommand' )
        cmd.expects( :process_options! ).with( [] )
        @cli.expects( :find_command ).with( 'dummy' ).returns( cmd )
        @cli.expects( :commands ).returns( ['dummy'] )

        process( 'dummy' )
      end
      
      it "should leftover arguments to dummy command for arguments 'dummy -z'" do
        cmd = mock( 'DummyCommand' )
        cmd.expects( :process_options! ).with( ['-z'] )
        @cli.expects( :find_command ).with( 'dummy' ).returns( cmd )
        @cli.expects( :commands ).returns( ['dummy'] )

        process( 'dummy', '-z' )
      end

    end

    describe "using INVALID arguments" do

      it "should use help command for invalid switch '-x'" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( ['unknown_switch','-x'] )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )

        process( '-x' )
      end

      it "should use help command for invalid argument 'chunkybacon'" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( ['unknown_command', 'chunkybacon'] )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )
        @cli.expects( :commands ).returns( ['help'] )

        process( 'chunkybacon' ) 
      end

    end
    
  end
  
end

