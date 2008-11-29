
# require 'sandbox/command'

class Sandbox::Commands::HelpCommand < Sandbox::Command
  
  ## CLASS METHODS
  class << self
  end
  ## END CLASS METHODS
  
  ## PUBLIC INSTANCE METHODS
  public
    def initialize
      super( 'help', "Provide help on general usage or individual commands" )
    end
    
    def execute!
      arg = options[ :args ].first
      if matches?( 'commands', arg )
        show_commands
      elsif arg
        unless Sandbox::CommandManager.command_names.include?( arg )
          raise Sandbox::UnknownCommandError.new( arg, "#{cli_string} commands" )
        end
        command = Sandbox::CommandManager[ arg ]
        # command.run( ["--help"] )
        command.show_help
      else
        show_application_help
      end
    end
    
    def usage
      "#{cli_string} ARGUMENT"
    end
    
    def arguments # :nodoc:
      [
        [ 'commands',   "List all 'sandbox' commands" ],
        [ '<command>',  "Show specific help for <command>" ]
      ].freeze
    end
    
    def show_commands
      # out = []
      # out << "Available commands for the sandbox utility:"
      # out << ""
      # cmds = Sandbox::CommandManager.command_names.collect do |n|
      #   cmd = Sandbox::CommandManager[ n ]
      #   [ cmd.name, cmd.summary ]
      # end
      # out.concat( nested_formatter( cmds ) )
      # out << ""
      # out << "For help on a particular command, use 'sandbox help COMMAND'."
      # out << nil
      # out << "Commands may be abbreviated, so long as they are unambiguous."
      # out << "e.g. 'sandbox h init' is short for 'sandbox help init'."
      cmds = Sandbox::CommandManager.command_names.collect do |n|
        cmd = Sandbox::CommandManager[ n ]
        [ cmd.name, cmd.summary ]
      end
      
      out = [ "Available commands for the sandbox utility:", nil ]
      out.concat( nested_formatter( cmds ) )
      out.concat( [ 
          nil,
          "For help on a particular command, use 'sandbox help COMMAND'.",
          nil,
          "Commands may be abbreviated, so long as they are unambiguous.",
          "e.g. 'sandbox h init' is short for 'sandbox help init'." 
        ] )
      puts out.join( "\n" )
    end
    
    def show_application_help
      puts %{
        
        Sandbox will create a virtual environment for development.
        This is a basic help message with pointers to more information.
        
          Usage:
            sandbox -h/--help
            sandbox -v/--version
            sandbox command [arguments...] [options...]
          
          Further help:
            sandbox help commands            list all 'sandbox' commands
            sandbox help <COMMAND>           show help on COMMAND
          
          Basic commands:
            init          Create a new sandbox
            list          List downloaded or remotely available ruby/rubygems versions
            help          Show detailed help on a specific command
      }.gsub(/^\s{6}/, "")
    end
  ## END PUBLIC INSTANCE METHODS
  
  
  ## PRIVATE INSTANCE METHODS
  private
    
  ## END PRIVATE INSTANCE METHODS
  
end