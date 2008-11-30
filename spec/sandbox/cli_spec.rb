
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'sandbox/cli'

describe Sandbox::CLI do
  
  describe "when creating an instance" do
    it "should raise an error when running from a loaded sandbox" do
      begin
        ENV[ 'SANDBOX' ] = 'something'
        lambda { Sandbox::CLI.new }.should raise_error( Sandbox::LoadedSandboxError )
      ensure
        ENV[ 'SANDBOX' ] = nil
      end
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
    
    it "should load the CommandManager" do
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
              should raise_error( Sandbox::UnknownSwitchError ) { |error| error.message.should =~ /-x\b/ }
        end

        it "should exit with message for invalid argument 'chunkybacon'" do
          processor( 'chunkybacon' ).
              should raise_error( Sandbox::UnknownCommandError ) { |error| error.message.should =~ /chunkybacon/ }
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
        processor( 'chunkybacon' ).should raise_error( Sandbox::UnknownCommandError )
      end

      it "should raise AmbiguousCommand for multiple matching commands" do
        mgr = mock( 'CommandManager' )
        mgr.expects( :find_command_matches ).with( 'chunky' ).returns( ['chunkybacon','chunkycheese'] )
        @cli.expects( :command_manager ).returns( mgr )
        processor( 'chunky' ).should raise_error( Sandbox::AmbiguousCommandError )
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

# describe Sandbox::Command do
#   
#   it "should have common options" do
#     copts = Sandbox::Command.common_parser_opts
#     copts.detect { |opt| opt.first.include?( '-h' ) }.should_not be_nil
#     copts.detect { |opt| opt.first.include?( '--help' ) }.should_not be_nil
#     copts.detect { |opt| opt.first.include?( '-v' ) }.should_not be_nil
#     copts.detect { |opt| opt.first.include?( '--verbose' ) }.should_not be_nil
#     copts.detect { |opt| opt.first.include?( '-q' ) }.should_not be_nil
#     copts.detect { |opt| opt.first.include?( '--quiet' ) }.should_not be_nil
#   end
#   
#   it "should require a name when calling 'new'" do
#     cmd = nil
#     lambda { Sandbox::Command.new }.
#         should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
#     lambda { cmd = Sandbox::Command.new( 'name' ) }.should_not raise_error()
#     cmd.name.should == 'name'
#   end
#   
#   it "takes an optional summary on creation" do
#     cmd = nil
#     lambda { cmd = Sandbox::Command.new( 'name', 'I command' ) }.should_not raise_error()
#     cmd.summary.should == 'I command'
#   end
#   
#   it "takes a hash as it's defaults and options on creation" do
#     cmd = nil
#     opts = { :something => true, :someone => :me }
#     lambda { cmd = Sandbox::Command.new( 'name', 'I command', opts ) }.should_not raise_error()
#     cmd.defaults[ :something ].should be_true
#     cmd.options[ :someone ].should == :me
#   end
#   
#   describe 'a new instance' do
# 
#     before( :each ) do
#       @cmd = Sandbox::Command.new( 'dummy', 'dummy summary' )
#     end
# 
#     it "should raise NotImplementedError on execute!" do
#       lambda { @cmd.execute! }.
#           should raise_error( NotImplementedError ) { |error| error.message.should =~ /must be implemented/ }
#     end
# 
#     it "should have a command string" do
#       @cmd.cli_string.should == "sandbox dummy"
#     end
# 
#     it "should have an empty description" do
#       @cmd.description.should be_nil
#     end
# 
#     it "should have a default usage" do
#       @cmd.usage.should == @cmd.cli_string
#     end
# 
#     it "should build a parser only when needed" do
#       opts = mock()
#       OptionParser.expects( :new ).once.then.returns( opts )
#       @cmd.instance_eval { @parser }.should be_nil
#       @cmd.parser
#       @cmd.instance_eval { @parser }.should == opts
#       @cmd.parser.should == opts
#     end
# 
#     it "should add common switches to parser" do
#       Sandbox::Command.expects( :common_parser_opts )
#       @cmd.parser
#     end
# 
#     it "should add local switches to parser" do
#       @cmd.expects( :parser_opts )
#       @cmd.parser
#     end
# 
#     describe "calling show_help" do
# 
#       it "should provide a default help message using usage" do
#         io = capture do
#           @cmd.show_help
#         end
#         io.stdout.should =~ /^Usage: #{@cmd.usage}/
#       end
# 
#       it "should show possible arguments when set" do
#         arg = [ 'ARGUMENT', 'an argument' ]
#         @cmd.stubs( :arguments ).returns( [ arg ] )
#         io = capture do
#           @cmd.show_help
#         end
#         io.stdout.should =~ /Arguments:/
#         io.stdout.should =~ /#{arg[0]}/
#         io.stdout.should =~ /#{arg[1]}/
#       end
# 
#       it "should show possible description when set" do
#         desc = "this is a description"
#         @cmd.stubs( :description ).returns( desc )
#         io = capture do
#           @cmd.show_help
#         end
#         io.stdout.should =~ /Description:/
#         io.stdout.should =~ /#{desc}/
#       end
# 
#     end
# 
#     describe "calling run" do
# 
#       def processor( *args ); lambda { @cmd.run( *args ) }; end
#       def process( *args ); processor( *args ).call; end
# 
#       it "should require array of arguements" do
#         @cmd.stubs( :execute! )
#         processor().should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
#         processor( [] ).should_not raise_error()
#         processor( [], true ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
#         processor( [], { :x => true } ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
#       end
# 
#       [ '-h', '--help' ].each do |arg|
#         it "should call show_help for option '#{arg}'" do
#           @cmd.expects( :show_help )
#           process( [arg] )
#         end
#       end
# 
#       it "should raise error on bad option" do
#         processor( [ '-x' ] ).
#             should raise_error( Sandbox::ParseError ) { |error| error.message.should =~ /-x/ }
#       end
# 
#     end
# 
#     describe "calling process_options!" do
# 
#       def processor( *args ); lambda { @cmd.process_options!( *args ) }; end
#       def process( *args ); processor( *args ).call; end
# 
#       it "should require array of arguments" do
#         processor().should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
#         processor( [] ).should_not raise_error( ArgumentError )
#         processor( [], true ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
#         processor( [], { :x => true } ).should raise_error( ArgumentError ) { |error| error.message.should =~ /2 for 1/ }
#       end
# 
#       describe "with valid arguments" do
#         
#         before( :each ) do
#           Sandbox.instance_eval { instance_variables.each { |v| remove_instance_variable v } }
#         end
#         
#         [ '-h', '--help' ].each do |arg|
#           it "should set help option for argument '#{arg}'" do
#             process( [arg] )
#             @cmd.options[ :help ].should be_true
#           end
#         end
# 
#         [ '-v', '--verbose' ].each do |arg|
#           it "should set verbosity option properly for argument '#{arg}'" do
#             Sandbox.verbosity.should == 0
#             process( [arg] )
#             # @cmd.options[ :verbosity ].should == 1
#             Sandbox.verbosity.should == 1
#           end
#         end
# 
#         it "should set verbosity option properly for argument '-vv'" do
#           Sandbox.verbosity.should == 0
#           process( ['-vv'] )
#           # @cmd.options[ :verbosity ].should == 2
#           Sandbox.verbosity.should == 2
#         end
# 
#         [ '-q', '--quiet' ].each do |arg|
#           it "should set verbosity option properly for argument '#{arg}'" do
#             Sandbox.verbosity.should == 0
#             process( [arg] )
#             # @cmd.options[ :verbosity ].should == -1
#             Sandbox.verbosity.should == -1
#           end
#         end
# 
#         it "should set verbosity option properly for argument '-qq'" do
#           Sandbox.verbosity.should == 0
#           process( ['-qq'] )
#           # @cmd.options[ :verbosity ].should == -2
#           Sandbox.verbosity.should == -2
#         end
# 
#         it "should save non-switch args into options" do
#           args = [ '-v', '/path/to/somewhere' ]
#           process( args )
#           @cmd.options[ :args ].should == args
#         end
# 
#       end
# 
#     end
# 
#   end
#   
# end


