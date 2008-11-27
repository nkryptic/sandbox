
require 'workspace'
# require 'workspace/command_manager'

module Workspace  
  class CLI
    
    ## CLASS METHODS
    class << self
      
      # invokes workspace via command-line ARGV as the options
      def execute( args = ARGV )
        if ENV[ 'WORKSPACE' ]
          raise InWorkspaceError, "You cannot run workspace while in a loaded workspace"
        end
        parse( args ).execute!
        
      rescue WorkspaceError => ex
        puts "Error: #{ex.message}"
        puts "see '#{ex.help_str}'" if ex.help_str
        exit( 1 )
      # rescue StandardError, Timeout::Error => ex
      #   alert_error "While executing gem ... (#{ex.class})\n    #{ex.to_s}"
      #   ui.errs.puts "\t#{ex.backtrace.join "\n\t"}" if
      #     Gem.configuration.backtrace
      #   exit( 1 )
      # rescue Interrupt
      #   alert_error "Interrupted"
      #   exit( 1 )
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
      if args.first =~ /^-/
        process_switch!( args.shift, args )
      elsif args.first
        @command_name = args.shift.to_s.downcase
        @command_args = args.slice!(0..-1)
      end
      @command_name = find_command( @command_name )
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
      raise AmbiguousCommand.new( cmd_name, matches ) if matches.size > 1
      
      matches.first
    end
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      attr_reader :command_manager, :command_name, :command_args
    
    ## END PRIVATE INSTANCE METHODS
    
  end
  
end
