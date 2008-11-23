
require 'workspace'
require 'workspace/command_manager'

module Workspace  
  class CLI
    
    ## CLASS METHODS
    class << self
      
      # invokes workspace via command-line ARGV as the options
      def execute( args = ARGV )
        parse( args ).execute!
      end
      
      # returns a new CLI instance which has parsed the given arguments.
      # will load the command to execute based upon the arguements.
      # if an error occurs, it will print out simple error message and exit 
      def parse( args )
        cli = new
        cli.parse_options!( args )
        cli
      end
    end
    ## END CLASS METHODS
    
    
    ## PUBLIC INSTANCE METHODS
    
    # setup of a new CLI instance and create CommandManager
    def initialize
      @options = {
        :debug => false
      }
      @command_manager = Workspace::CommandManager.new
    end
    
    # processes +args+ to:
    # 
    # * load global option for the application
    # * determine command name to lookup in CommandManager
    # * load command and have it process any add't options
    # * catches exceptions for unknown switches or commands
    def parse_options!( args )   
      command_name = nil
      command_options = []
      
      begin
        while command_name.nil? do
          case arg = args.shift
            when '-h', '--help', nil
              command_name = 'help'
            when '-v', '--version'
              puts "workspace v#{ Workspace::Version::STRING }"
              exit
            when '-d', '--debug'
              @options[ :debug ] = true
            when /^-/
              raise UnknownSwitch.new( arg )
          else
            command_name = arg.to_s.downcase
            command_options = args
          end
        end
        
        @command = find_command( command_name )
        
      rescue UnknownSwitch, UnknownCommand, AmbiguousCommand => e
        @command = get_command( 'help' )
        command_options = [ e ]
      end
      
      if @command
        @command.process_options!( command_options, @options )
      end
    end
    
    # retrieves the command from CommandManager with name +cmd_name+
    def get_command( cmd_name )
      command_manager[ cmd_name ]
    end
    
    # returns the command instance which matches +cmd_name+
    # it performs partial matches to allow shortcuts
    # raises errors for no or many matches
    def find_command( cmd_name )
      matches = command_manager.find_command_matches( cmd_name )
      
      raise UnknownCommand.new( cmd_name ) if matches.size < 1
      raise AmbiguousCommand.new( *matches ) if matches.size > 1
      
      get_command( matches.first )
    end
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      attr_reader :options, :command_manager
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
