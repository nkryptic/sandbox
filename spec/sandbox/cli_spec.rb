
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'sandbox/cli'

describe Sandbox::CLI do
  
  describe "calling execute" do
    
    before( :each ) do
      @instance = stub_everything()
    end
    
    it "should exit with error when running from a loaded sandbox" do
      begin
        ENV[ 'SANDBOX' ] = 'something'
        lambda { Sandbox::CLI.execute }.should raise_error( SystemExit ) { |error| error.status.should == 1 }
      rescue
        raise
      ensure
        ENV[ 'SANDBOX' ] = nil
      end
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
    
    it "should load a new CommandManager" do
      @cli.send( :command_manager ).should == Sandbox::CommandManager
    end
    
    describe "instance calling parse_args!" do
      
      def processor( *args ); lambda { @cli.parse_args!( args ) }; end
      def process( *args ); processor( *args ).call; end

      describe "using NO arguments" do

        it "should use help command" do
          @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
          process()
          Sandbox::CLI.publicize_methods do
            @cli.command_name.should == 'help'
            @cli.command_args.should == []
          end
        end

      end

      describe "using VALID arguments" do

        [ '-V', '--version' ].each do |arg|
          it "should print the version for switch '#{arg}'" do
            @cli.expects(:puts).with( "sandbox v#{Sandbox::Version::STRING}" )
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
            Sandbox::CLI.publicize_methods do
              @cli.command_name.should == 'help'
              @cli.command_args.should == []
            end
          end
        end

        [ '-h', '--help' ].each do |arg|
          it "should ignore additional switch after '#{arg}'" do
            @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
            process( arg, '-x' )
            Sandbox::CLI.publicize_methods do
              @cli.command_name.should == 'help'
              @cli.command_args.should == []
            end
          end
        end

        [ '-h', '--help' ].each do |arg|
          it "should ignore additional arguments after '#{arg}'" do
            @cli.expects( :find_command ).with( 'help' ).returns( 'help' )
            process( arg, 'unknown' )
            Sandbox::CLI.publicize_methods do
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
          Sandbox::CLI.publicize_methods do
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
          Sandbox::CLI.publicize_methods do
            @cli.command_name.should == 'dummy'
            @cli.command_args.should == ['-z']
          end
        end

      end

      describe "using INVALID arguments" do

        it "should exit with message for invalid switch '-x'" do
          processor( '-x' ).
              should raise_error( Sandbox::UnknownSwitch ) { |error| error.message.should =~ /-x\b/ }
        end

        it "should exit with message for invalid argument 'chunkybacon'" do
          processor( 'chunkybacon' ).
              should raise_error( Sandbox::UnknownCommand ) { |error| error.message.should =~ /chunkybacon/ }
        end

      end

    end

    describe "instance calling find_command" do

      before( :each ) do
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
        processor( 'chunkybacon' ).should raise_error( Sandbox::UnknownCommand )
      end

      it "should raise AmbiguousCommand for multiple matching commands" do
        mgr = mock( 'CommandManager' )
        mgr.expects( :find_command_matches ).with( 'chunky' ).returns( ['chunkybacon','chunkycheese'] )
        @cli.expects( :command_manager ).returns( mgr )
        processor( 'chunky' ).should raise_error( Sandbox::AmbiguousCommand )
      end

    end

    describe "instance calling command_manager" do

      it "should ask command manager for 'help' command" do
        Sandbox::CommandManager.expects( :find_command_matches ).with( 'help' ).returns( ['help'] )
        @cli.parse_args!( ['-h'] )
        Sandbox::CLI.publicize_methods do
          @cli.command_name.should == 'help'
          @cli.command_args.should == []
        end
      end

    end

    describe "instance calling execute!" do

      it "should ask command manager for 'help' command" do
        cmd = mock()
        cmd.expects( :run ).with( [] )
        Sandbox::CommandManager.expects( :[] ).with( 'help' ).returns( cmd )
        @cli.execute!
      end

    end
    
  end
  
end

