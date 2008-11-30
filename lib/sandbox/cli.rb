
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
      
      # pretty error handling
      def handle_error( error )
        case error
          when Sandbox::Error
            abort( error.message )
          when StandardError #, Timeout::Error
            message = [ "Error: #{error.message}" ]
            message.concat( error.backtrace.collect { |bt| "    #{bt}" } ) if Sandbox.really_verbose?
            abort( message.join( "\n" ) )
          when Interrupt
            abort( "Interrupted" )
        else
          raise error
        end
      end
    end
    ## END CLASS METHODS
    
    DEFAULTS = {
      :gems => [ 'rake', ]
    }
    
    ## PUBLIC INSTANCE METHODS
    
    # The options for this execution.
    attr_reader :options
    
    # setup of a new CLI instance
    def initialize
      @options = DEFAULTS.dup
      @parser = nil
      verify_environment!
    end
    
    
    # get and run the command
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
      @parser ||= OptionParser.new do |o|
        o.set_summary_indent('  ')
        o.program_name = 'sandbox TARGET'
        o.define_head "Create virtual ruby/rubygems sandboxes."
        o.separator ""
        
        o.separator "ARGUMENTS:"
        o.separator "  TARGET      Target path to new sandbox.  Must not exist beforehand."
        o.separator ""
        
        o.separator "OPTIONS"
        o.on( '-g', '--gems gem1,gem2', Array, 'Gems to install after sandbox is created. (defaults to [rake])' ) { |gems| @options[ :gems ] = gems }
        o.on( '-n', '--no-gems', 'Do not install any gems after sandbox is created.)' ) { @options[ :gems ] = [] }
        o.on( '-q', '--quiet', 'Show less output. (multiple allowed)' ) { |f| Sandbox.decrease_verbosity }
        o.on( '-v', '--verbose', 'Show more output. (multiple allowed)' ) { |f| Sandbox.increase_verbosity }
        o.on_tail( '-h', '--help', 'Show this help message and exit.' ) { puts o; exit }
        o.on_tail( '-H', '--long-help', 'Show the full description about the program' ) { puts long_help; exit }
        o.on_tail( '-V', '--version', 'Display the program version and exit.' ) { puts o; exit }
        o.separator ""
      end
    end
    
    def show_help
      puts parser
    end
    
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
        environment which may be activated by the script `bin/activate` in your
        sandbox directory.
        
        Run the script with the following to enable your new environment:
          $ source bin/activate
        
        When you want to leave the environment:
          $ deactivate
        
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
    # # Merge a set of command options with the set of default options
    # # (without modifying the default option hash).
    # def merge_options(new_options)
    #   @options = @defaults.clone
    #   new_options.each do |k,v| @options[k] = v end
    # end
    
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
    
      def raise_parse_error( reason, args=[] )
        raise Sandbox::ParseError.new( reason, args )
      end
      
      def verify_environment!
        raise LoadedSandboxError if ENV[ 'SANDBOX' ]
      end
    
    ## END PRIVATE INSTANCE METHODS
    
  end
  
end
