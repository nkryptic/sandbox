
require 'workspace'
require 'workspace/command_manager'

module Workspace  
  class CLI
    
    ## CLASS METHODS
    class << self
      
      # invokes workspace via command-line ARGV as the options
      def execute( args = ARGV )
        if ENV[ 'WORKSPACE' ]
          puts "Error: You cannot run workspace while in a loaded workspace."
          exit( 1 )
        end
        parse( args ).execute!
      end
      
      # returns a new CLI instance which has parsed the given arguments.
      # will load the command to execute based upon the arguements.
      # if an error occurs, it will print out simple error message and exit 
      def parse( args )
        cli = new
        cli.parse_args!( args )
        cli
      end
    end
    ## END CLASS METHODS
    
    
    ## PUBLIC INSTANCE METHODS
    
    # setup of a new CLI instance and create CommandManager
    def initialize
      @command = nil
      @command_name = 'help'
      @command_args = []
      @command_manager = Workspace::CommandManager
    end
    
    
    # get and run the command
    def execute!
      command_manager[ @command_name ].run( @command_args )
    end
    
    # processes +args+ to:
    # 
    # * load global option for the application
    # * determine command name to lookup in CommandManager
    # * load command and have it process any add't options
    # * catches exceptions for unknown switches or commands
    def parse_args!( args )
      begin
        if args.first =~ /^-/
          process_switch!( args.shift, args )
        elsif args.first
          @command_name = args.shift.to_s.downcase
          @command_args = args.slice!(0..-1)
        end
        @command_name = find_command( @command_name )
      rescue UnknownSwitch, UnknownCommand, AmbiguousCommand => ex
        @command_name = 'help'
        @command_args = [ ex ]
      end
    end
    
    def process_switch!( arg, args )
      case arg
        when '-h', '--help'
          args.clear
        when '-V', '--version'
          puts "workspace v#{ Workspace::Version::STRING }"
          exit
      else
        raise UnknownSwitch.new( arg )
      end
    end
    
    # returns the command instance which matches +cmd_name+
    # it performs partial matches to allow shortcuts
    # raises errors for no or many matches
    def find_command( cmd_name )
      matches = command_manager.find_command_matches( cmd_name )
      
      raise UnknownCommand.new( cmd_name ) if matches.size < 1
      raise AmbiguousCommand.new( *matches ) if matches.size > 1
      
      matches.first
    end
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      attr_reader :command_manager, :command_name, :command_args
      
      # def command_manager
      #   @command_manager ||= Workspace::CommandManager.new
      # end
    ## END PRIVATE INSTANCE METHODS
    
    
    class UnknownCommand < Exception
      def initialize( arg )
        @arguement = arg
      end
    end
    class AmbiguousCommand < Exception
      def initialize( *args )
        @commands = args
      end
    end
    class UnknownSwitch < Exception
      def initialize( arg )
        @switch = arg
      end
    end
    
  end
  
end
