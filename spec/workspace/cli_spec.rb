
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
  
  describe "creating an instance" do
    
    it "should load a new CommandManager" do
      Workspace::CommandManager.expects( :new )
      
      Workspace::CLI.new
    end
    
  end
  
  describe "instance calling parse_options!" do
    
    before( :each ) do
      @cli = Workspace::CLI.new
    end
    def processor( *args ); lambda { @cli.parse_options!( args ) }; end
    def process( *args ); processor( *args ).call; end
    
    describe "using NO arguments" do
      
      it "should use help command" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( [], { :debug => false } )
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
          Workspace::CLI.publicize_methods do
            @cli.options[ :debug ].should be_true
          end
        end
      end

      [ '-d', '--debug' ].each do |arg|
        it "should not ignore additional arguments after '#{arg}'" do
          cmd = mock( 'DummyCommand' )
          cmd.expects( :process_options! ).with( ['-z'], { :debug => true } )
          @cli.expects( :find_command ).with( 'dummy' ).returns( cmd )
          # @cli.expects( :commands ).returns( ['dummy'] )

          process( arg, 'dummy', '-z' )
          Workspace::CLI.publicize_methods do
            @cli.options[ :debug ].should be_true
          end
        end
      end

      [ '-h', '--help', nil ].each do |arg|
        it "should use help command for switch '#{arg}'" do
          cmd = mock( 'HelpCommand' )
          cmd.expects( :process_options! ).with( [], { :debug => false } )
          @cli.expects( :find_command ).with( 'help' ).returns( cmd )

          process( arg ) 
        end
      end

      [ '-h', '--help' ].each do |arg|
        it "should ignore additional arguments after '#{arg}'" do
          cmd = mock( 'HelpCommand' )
          cmd.expects( :process_options! ).with( [], { :debug => false } )
          @cli.expects( :find_command ).with( 'help' ).returns( cmd )

          process( arg, '-x' )
        end
      end

      it "should use help command for argument 'help'" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( [], { :debug => false } )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )
        # @cli.expects( :commands ).returns( ['help'] )

        process( 'help' ) 
      end

      it "should use help command for arguments 'help dummy'" do
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( ['dummy'], { :debug => false } )
        @cli.expects( :find_command ).with( 'help' ).returns( cmd )
        # @cli.expects( :commands ).returns( ['help'] )

        process( 'help', 'dummy' )
      end

      it "should use dummy command for argument 'dummy'" do
        cmd = mock( 'DummyCommand' )
        cmd.expects( :process_options! ).with( [], { :debug => false } )
        @cli.expects( :find_command ).with( 'dummy' ).returns( cmd )
        # @cli.expects( :commands ).returns( ['dummy'] )

        process( 'dummy' )
      end
      
      it "should pass leftover arguments to dummy command for arguments 'dummy -z'" do
        cmd = mock( 'DummyCommand' )
        cmd.expects( :process_options! ).with( ['-z'], { :debug => false } )
        @cli.expects( :find_command ).with( 'dummy' ).returns( cmd )
        # @cli.expects( :commands ).returns( ['dummy'] )

        process( 'dummy', '-z' )
      end

    end

    describe "using INVALID arguments" do

      it "should use help command for invalid switch '-x'" do
        err = Workspace::CLI::UnknownSwitch.new( '-x' )
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( [err], { :debug => false } )
        @cli.expects( :raise ).raises( err )
        @cli.expects( :get_command ).with( 'help' ).returns( cmd )

        process( '-x' )
      end

      it "should use help command for invalid argument 'chunkybacon'" do
        err = Workspace::CLI::UnknownCommand.new( 'chunkybacon' )
        cmd = mock( 'HelpCommand' )
        cmd.expects( :process_options! ).with( [err], { :debug => false } )
        @cli.expects( :find_command ).with( 'chunkybacon' ).raises( err )
        @cli.expects( :get_command ).with( 'help' ).returns( cmd )

        process( 'chunkybacon' ) 
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
      known = mock( 'KnownCommand' )
      mgr = mock( 'CommandManager' )
      mgr.expects( :find_command_matches ).with( 'known' ).returns( ['known'] )
      @cli.expects( :command_manager ).returns( mgr )
      @cli.expects( :get_command ).with( 'known' ).returns( known )
      
      process( 'known' ).should == known
    end
    
    it "should find a valid command for partial match on argument" do
      known = mock( 'KnownCommand' )
      mgr = mock( 'CommandManager' )
      mgr.expects( :find_command_matches ).with( 'kno' ).returns( ['known'] )
      @cli.expects( :command_manager ).returns( mgr )
      @cli.expects( :get_command ).with( 'known' ).returns( known )
      
      process( 'kno' ).should == known
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
  
  describe "instance calling get_command" do
    
    before( :each ) do
      @cli = Workspace::CLI.new
    end
    def processor( cmd_name ); lambda { @cli.get_command( cmd_name ) }; end
    def process( cmd_name ); processor( cmd_name ).call; end
    
    it "should ask command_manager and get matching command" do
      known = mock( 'KnownCommand' )
      mgr = mock( 'CommandManager' )
      mgr.expects( :[] ).with( 'known' ).returns( known )
      @cli.expects( :command_manager ).returns( mgr )
      
      process( 'known' ).should == known
    end
    
    it "should ask command_manager and not unknown command" do
      mgr = mock( 'CommandManager' )
      mgr.expects( :[] ).with( 'unknown' ).returns( nil )
      @cli.expects( :command_manager ).returns( mgr )
      
      process( 'unknown' ).should be_nil
    end
    
  end
  
  describe "instance calling command_manager" do
    
    before( :each ) do
      @mgr = mock( 'CommandManager' )
      Workspace::CommandManager.stubs( :new ).once.then.returns( @mgr )
      @cli = Workspace::CLI.new
    end
    
    it "should ask command manager for 'help' command" do
      cmd = mock()
      @mgr.expects( :find_command_matches ).with( 'help' ).returns( ['help'] )
      @mgr.expects( :[] ).with( 'help' )
      
      @cli.parse_options!( ['-h'] )
    end
    
  end
  
end

