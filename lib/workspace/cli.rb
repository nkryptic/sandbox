require 'optparse'
require 'workspace'

module Workspace
  # class CommandManager
  #   # include Singleton
  #   class << self
  #     attr_reader :commands
  #     
  #     # def initialize
  #     #   @commands = {}
  #     # end
  #     
  #     def register( name, klass )
  #       @commands ||= {}
  #       @command[ name ] = klass
  #     end
  #     
  #     # def actions
  #     #   return @action_names if @action_names
  #     #   @action_names = @commands.keys
  #     #   @action_names.sort
  #     # end
  #   end
  #   ##############
  #   # FROM RUBYGEMS
  #   
  #   def find_command(cmd_name)
  #     possibilities = find_command_possibilities(cmd_name)
  #     if possibilities.size > 1
  #       raise "Ambiguous command #{cmd_name} matches [#{possibilities.join(', ')}]"
  #     end
  #     if possibilities.size < 1
  #       raise "Unknown command #{cmd_name}"
  #     end
  #   
  #     self[possibilities.first]
  #   end
  #   
  #   def find_command_possibilities(cmd_name)
  #     len = cmd_name.length
  #     self.command_names.select { |n| cmd_name == n[0,len] }
  #   end
  #   
  #   private
  #   
  #   def load_and_instantiate(command_name)
  #     command_name = command_name.to_s
  #     retried = false
  #   
  #     begin
  #       const_name = command_name.capitalize.gsub(/_(.)/) { $1.upcase }
  #       Gem::Commands.const_get("#{const_name}Command").new
  #     rescue NameError
  #       if retried then
  #         raise
  #       else
  #         retried = true
  #         require "rubygems/commands/#{command_name}_command"
  #         retry
  #       end
  #     end
  #   end
  #   # END
  #   #####
  # end
  
  # class Command
  #   def self.inherited( klass )
  #     parts = klass.to_s.split( '::' )
  #     name = parts.last.downcase
  #     CommandManager.instance.register( name, klass )
  #   end
  # end
  
  class CLI
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
    
    class << self
      # attr_writer :step_mother, :executor, :features
      
      def execute( args = ARGV )
        parse( args ).execute!
        # @execute_called = true
        # parse( ARGV ).execute!( @step_mother, @executor, @features )
      end
    
      # def execute_called?
      #   @execute_called
      # end
    
      def parse( args )
        cli = new
        cli.parse_options!(args)
        cli
      end
    end
    
    attr_reader :options#, :command
    # attr_reader :debug
    
    # def initialize( out_stream = STDOUT, error_stream = STDERR )
    def initialize
      @options = {
        :debug => false
      }
      # @command_manager = Workspace::CommandManager # .instance
    end
    
    def parse_options!( args )   
      command_name = nil
      command_options = []
      # arg = args.shift
      
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
              # command_name = 'help'
              # command_options << 'unknown_switch' << arg
          else
            command_name = arg.to_s.downcase
            command_options = args
            # if find_command( command_name )
            # # if commands.include?( command_name )
            #   command_options = args
            # else
            #   command_name = 'help'
            #   command_options << 'unknown_command' << arg.to_s.downcase
            # end
          end
        end
        
        @command = find_command( command_name )
        
      rescue UnknownSwitch, UnknownCommand, AmbiguousCommand => e
        @command = get_command( 'help' )
        command_options = [ e ]
      end
      
      if @command
        @command.process_options!( command_options )
      end
    end
    
    def get_command( cmd_name )
      command_manager[ cmd_name ]
    end
    
    def find_command( cmd_name )
      matches = command_manager.find_command_matches( cmd_name )
      
      raise UnknownCommand.new( cmd_name ) if matches.size < 1
      raise AmbiguousCommand.new( *matches ) if matches.size > 1
      
      get_command( matches.first )
    end
  
  end
end
