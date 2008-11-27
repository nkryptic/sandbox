
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/cli'

describe Workspace::CLI do
  
  describe "calling execute" do
    
    before( :each ) do
      @instance = stub_everything()
    end
    
    it "should exit with error when running from a loaded workspace" do
      begin
        ENV[ 'WORKSPACE' ] = 'something'
        lambda { Workspace::CLI.execute }.should raise_error( SystemExit ) { |error| error.status.should == 1 }
      rescue
        raise
      ensure
        ENV[ 'WORKSPACE' ] = nil
      end
    end
    
    it "should attempt to parse ARGV by default" do
      Workspace::CLI.expects( :parse ).with( ARGV ).returns( @instance )
      Workspace::CLI.execute
    end
    
    it "should create a new instance" do
      Workspace::CLI.expects( :new ).returns( @instance )
      Workspace::CLI.execute
    end
    
    it "should call parse_args! on the new instance" do
      @instance.expects( :parse_args! )
      Workspace::CLI.expects( :new ).returns( @instance )
      Workspace::CLI.execute
    end
    
    it "should run the instance" do
      @instance.expects( :execute! )
      Workspace::CLI.expects( :parse ).returns( @instance )
      Workspace::CLI.execute
    end
    
  end
  
  describe "creating an instance" do
    
    it "should load a new CommandManager" do
      # Workspace::CommandManager.expects( :new )
      @cli = Workspace::CLI.new
      @cli.send( :command_manager ).should == Workspace::CommandManager
    end
    
  end
  
  describe "instance calling parse_args!" do
    
    before( :each ) do
      @cli = Workspace::CLI.new
    end
    def processor( *args ); lambda { @cli.parse_args!( args ) }; end
    def process( *args ); processor( *args ).call; end
    
    describe "using NO arguments" do
      
      it "should use help command" do
        @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
        process()
        Workspace::CLI.publicize_methods do
          @cli.command_name.should == 'help'
          @cli.command_args.should == []
        end
      end
      
    end
    
    describe "using VALID arguments" do

      [ '-V', '--version' ].each do |arg|
        it "should print the version for switch '#{arg}'" do
          @cli.expects(:puts).with( "workspace v#{Workspace::Version::STRING}" )
          processor( arg ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
        end
      end

      [ '-V', '--version' ].each do |arg|
        it "should ignore additional arguments after '#{arg}'" do
          @cli.stubs(:puts)
          processor( arg, '-x' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
          processor( arg, 'unknown' ).should raise_error( SystemExit ) { |error| error.status.should == 0 }
        end
      end

      [ '-h', '--help', nil ].each do |arg|
        it "should use help command for switch '#{arg}'" do
          @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
          process( arg ) 
          Workspace::CLI.publicize_methods do
            @cli.command_name.should == 'help'
            @cli.command_args.should == []
          end
        end
      end

      [ '-h', '--help' ].each do |arg|
        it "should ignore additional switch after '#{arg}'" do
          @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
          process( arg, '-x' )
          Workspace::CLI.publicize_methods do
            @cli.command_name.should == 'help'
            @cli.command_args.should == []
          end
        end
      end
      
      [ '-h', '--help' ].each do |arg|
        it "should ignore additional arguments after '#{arg}'" do
          @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
          process( arg, 'unknown' )
          Workspace::CLI.publicize_methods do
            @cli.command_name.should == 'help'
            @cli.command_args.should == []
          end
        end
      end

      it "should use help command for argument 'help'" do
        @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
        process( 'help' ) 
      end

      it "should use help command for arguments 'help dummy'" do
        @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
        process( 'help', 'dummy' )
        Workspace::CLI.publicize_methods do
          @cli.command_name.should == 'help'
          @cli.command_args.should == ['dummy']
        end
      end

      it "should use dummy command for argument 'dummy'" do
        @cli.expects( :find_command ).with( 'dummy' ).returns( 'dummy' )
        process( 'dummy' )
      end
      
      it "should pass leftover arguments to dummy command for arguments 'dummy -z'" do
        @cli.expects( :find_command ).with( 'dummy' ).returns( 'dummy' )
        process( 'dummy', '-z' )
        Workspace::CLI.publicize_methods do
          @cli.command_name.should == 'dummy'
          @cli.command_args.should == ['-z']
        end
      end

    end

    describe "using INVALID arguments" do

      it "should use help command for invalid switch '-x'" do
        err = Workspace::CLI::UnknownSwitch.new( '-x' )
        @cli.expects( :raise ).raises( err )
        process( '-x' )
        Workspace::CLI.publicize_methods do
          @cli.command_name.should == 'help'
          @cli.command_args.should == [err]
        end
      end

      it "should use help command for invalid argument 'chunkybacon'" do
        err = Workspace::CLI::UnknownCommand.new( 'chunkybacon' )
        @cli.expects( :find_command ).with( 'chunkybacon' ).raises( err )
        process( 'chunkybacon' ) 
        Workspace::CLI.publicize_methods do
          @cli.command_name.should == 'help'
          @cli.command_args.should == [err]
        end
      end

    end
    
  end
  
  describe "instance calling find_command" do
    
    before( :each ) do
      @cli = Workspace::CLI.new
      @cmds = { 'help' => mock( 'HelpCommand' ), 'known' => mock( 'KnownCommand' ) }
    end
    def processor( cmd_name ); lambda { @cli.find_command( cmd_name ) }; end
    def process( cmd_name ); processor( cmd_name ).call; end
    
    it "should find a valid command" do
      mgr = mock( 'CommandManager' )
      mgr.expects( :find_command_matches ).with( 'known' ).returns( ['known'] )
      @cli.expects( :command_manager ).returns( mgr )
      process( 'known' ).should == 'known'
    end
    
    it "should find a valid command for partial match on argument" do
      mgr = mock( 'CommandManager' )
      mgr.expects( :find_command_matches ).with( 'kno' ).returns( ['known'] )
      @cli.expects( :command_manager ).returns( mgr )
      process( 'kno' ).should == 'known'
    end
    
    it "should raise UnknownCommand for a non-existant command" do
      mgr = mock( 'CommandManager' )
      mgr.expects( :find_command_matches ).returns( [] )
      @cli.expects( :command_manager ).returns( mgr )
      processor( 'chunkybacon' ).should raise_error( Workspace::CLI::UnknownCommand )
    end
    
    it "should raise AmbiguousCommand for multiple matching commands" do
      mgr = mock( 'CommandManager' )
      mgr.expects( :find_command_matches ).with( 'chunky' ).returns( ['chunkybacon','chunkycheese'] )
      @cli.expects( :command_manager ).returns( mgr )
      processor( 'chunky' ).should raise_error( Workspace::CLI::AmbiguousCommand )
    end
    
  end
  
  describe "instance calling command_manager" do
    
    before( :each ) do
      # @mgr = mock( 'CommandManager' )
      # Workspace::CommandManager.stubs( :new ).once.then.returns( @mgr )
      @cli = Workspace::CLI.new
    end
    
    it "should ask command manager for 'help' command" do
      Workspace::CommandManager.expects( :find_command_matches ).with( 'help' ).returns( ['help'] )
      @cli.parse_args!( ['-h'] )
      Workspace::CLI.publicize_methods do
        @cli.command_name.should == 'help'
        @cli.command_args.should == []
      end
    end
    
  end
  
  describe "instance calling execute!" do
    
    before( :each ) do
      # @mgr = mock( 'CommandManager' )
      # Workspace::CommandManager.stubs( :new ).once.then.returns( @mgr )
      @cli = Workspace::CLI.new
    end
    
    it "should ask command manager for 'help' command" do
      cmd = mock()
      cmd.expects( :run ).with( [] )
      Workspace::CommandManager.expects( :[] ).with( 'help' ).returns( cmd )
      @cli.execute!
    end
    
  end
  
end

