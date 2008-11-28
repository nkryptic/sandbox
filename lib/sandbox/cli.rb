
require 'sandbox'
# require 'sandbox/command_manager'

module Sandbox  
  class CLI
    
    ## CLASS METHODS
    class << self
      
      # invokes sandbox via command-line ARGV as the options
      def execute( args = ARGV )
        parse( args ).execute!
      rescue Exception => error
        handle_error( error )
      end
      
      # returns a new CLI instance which has parsed the given arguments.
      # will load the command to execute based upon the arguements.
      # if an error occurs, it will print out simple error message and exit 
      def parse( args )
        cli = new
        cli.parse_args!( args )
        cli
      end
      
      def handle_error( error )
        case error
          # when Net::SSH::AuthenticationFailed
          #   abort "authentication failed for `#{error.message}'"
          when Sandbox::Error
            abort( error.message )
          # when StandardError, Timeout::Error
          #   alert_error "While executing gem ... (#{ex.class})\n    #{ex.to_s}"
          #   ui.errs.puts "\t#{ex.backtrace.join "\n\t"}" if
          #     Gem.configuration.backtrace
          #   exit( 1 )
          # when Interrupt
          #   alert_error "Interrupted"
          #   exit( 1 )
        else
          raise error
        end
      end
    end
    ## END CLASS METHODS
    
    
    ## PUBLIC INSTANCE METHODS
    
    # setup of a new CLI instance and create CommandManager
    def initialize
      @command = nil
      @command_name = 'help'
      @command_args = []
      @command_manager = Sandbox::CommandManager
      
      verify_environment!
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
          puts "sandbox v#{ Sandbox::Version::STRING }"
          exit
      else
        raise Sandbox::UnknownSwitchError.new( arg )
      end
    end
    
    # returns the command instance which matches +cmd_name+
    # it performs partial matches to allow shortcuts
    # raises errors for no or many matches
    def find_command( cmd_name )
      matches = command_manager.find_command_matches( cmd_name )
      
      raise Sandbox::UnknownCommandError.new( cmd_name ) if matches.size < 1
      raise Sandbox::AmbiguousCommandError.new( cmd_name, matches ) if matches.size > 1
      
      matches.first
    end
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      attr_reader :command_manager, :command_name, :command_args
      
      def verify_environment!
        raise LoadedSandboxError if ENV[ 'SANDBOX' ]
      end
    
    ## END PRIVATE INSTANCE METHODS
    
  end
  
end
