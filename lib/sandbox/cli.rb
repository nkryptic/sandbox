
require 'optparse'
require 'sandbox'

module Sandbox  
  class CLI
    include Sandbox::Output
    extend Sandbox::Output
    
    DEFAULTS = {
      # :gems => [ 'rake', ]
      :gems => []
    }
    
    ## CLASS METHODS
    class << self
      
      # invokes sandbox via command-line ARGV as the options
      def execute( args = ARGV )
        verify_environment!
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
      
      def verify_environment!
        raise LoadedSandboxError if ENV[ 'SANDBOX' ]
      end
      
      # pretty error handling
      def handle_error( error )
        case error
          when Sandbox::Error
            tell_unless_really_quiet( error.message )
          when StandardError #, Timeout::Error
            tell_unless_really_quiet( "Error: #{error.message}" )
            tell_when_really_verbose( error.backtrace.collect { |bt| "    #{bt}" }.join( "\n" ) ) if error.backtrace
          when Interrupt
            tell_unless_really_quiet( "Interrupted" )
        else
          raise error
        end
      end
      
    end
    ## END CLASS METHODS
    
    ## PUBLIC INSTANCE METHODS
    public
    
    # The options for this execution.
    attr_reader :options
    
    # setup of a new CLI instance
    def initialize
      @options = DEFAULTS.dup
      @parser = nil
    end
    
    
    # perform the sandbox creation
    def execute!
      targets = options.delete( :args )
      
      if targets.size < 1
        raise Sandbox::Error.new( 'no target specified - see `sandbox --help` for assistance' )
      elsif targets.size > 1
        raise Sandbox::Error.new( 'multiple targets specified - see `sandbox --help` for assistance' )
      end
      
      options[ :target ] = targets[0]
      
      Sandbox::Installer.new( options ).populate
    end
    
    # processes +args+ to:
    # 
    # * load global option for the application
    # * determine command name to lookup in CommandManager
    # * load command and have it process any add't options
    # * catches exceptions for unknown switches or commands
    def parse_args!( args )
      options[ :original_args ] = args.dup
      parser.parse!( args )
    rescue OptionParser::ParseError => ex
      raise_parse_error( ex.reason, ex.args )
    else
      options[ :args ] = args
    end
    
    def parser
      @parser ||= create_parser
    end
    
    def create_parser
      OptionParser.new do |o|
        o.set_summary_indent('  ')
        o.program_name = 'sandbox TARGET'
        o.define_head "Create virtual ruby/rubygems sandboxes."
        o.separator ""
        
        o.separator "ARGUMENTS:"
        o.separator "  TARGET      Target path to new sandbox.  Must not exist beforehand."
        o.separator ""
        
        o.separator "OPTIONS"
        o.on( '-g', '--gems gem1,gem2', Array, 'Gems to install after sandbox is created.' ) { |gems| @options[ :gems ] = gems }
        o.on( '-n', '--no-gems', 'Do not install any gems after sandbox is created.' ) { @options[ :gems ] = [] }
        o.on( '-q', '--quiet', 'Show less output. (multiple allowed)' ) { |f| Sandbox.decrease_verbosity }
        o.on( '-v', '--verbose', 'Show more output. (multiple allowed)' ) { |f| Sandbox.increase_verbosity }
        o.on_tail( '-h', '--help', 'Show this help message and exit.' ) { tell_unless_really_quiet( o ); exit }
        o.on_tail( '-H', '--long-help', 'Show the full description about the program' ) { tell_unless_really_quiet( long_help ); exit }
        o.on_tail( '-V', '--version', 'Display the program version and exit.' ) { tell_unless_really_quiet( Sandbox::Version::STRING ); exit }
        o.separator ""
      end
    end
    
    # def show_help
    #   tell( parser )
    # end
    
    def long_help
      unindent( <<-HELP )
      --------------------------------------------------------------------------------
        Sandbox is a utility to create sandboxed Ruby/Rubygems environments.
        
        It is meant to address the following issues:
        1. Conflicts with unspecified gem dependency versions.
        2. Applications can have their own gem repositories.
        3. Permissions for installing your own gems.
        4. Ability to try gems out without installing into your global repository.
        5. A Simple way to enable this.
        
        Running from your own gem repositories is fairly straight-forward, but 
        managing the necessary environment is a pain.  This utility will create a new
        environment which may be activated by the script `bin/activate_sandbox` in
        your sandbox directory.
        
        Run the script with the following to enable your new environment:
          $ source bin/activate_sandbox
        
        When you want to leave the environment:
          $ deactivate_sandbox
        
        NOTES:
        1. It creates an environment that has its own installation directory for Gems.
        2. It doesn't share gems with other sandbox environments.
        3. It (optionally) doesn't use the globally installed gems either.
        4. It will use a local to the sandbox .gemrc file
        
        WARNINGS:
        Activating your sandbox environment will change your HOME directory
        temporarily to the sandbox directory.  Other environment variables are set to
        enable this funtionality, so if you may experience odd behavior.  Everything
        should be reset when you deactivate the sandbox.
      HELP
    end
    
    def unindent( output )
      indent = output[/\A\s*/]
      output.strip.gsub(/^#{indent}/, "")
    end
    
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
    
    def raise_parse_error( reason, args=[] )
        raise Sandbox::ParseError.new( reason, args )
      end
    
    ## END PRIVATE INSTANCE METHODS
    
  end
  
end
