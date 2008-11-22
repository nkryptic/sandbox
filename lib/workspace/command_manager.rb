module Workspace
  class CommandManager
    
    # include Singleton
    
    ## CLASS METHODS
    class << self
      # attr_reader :commands
      # 
      # # def initialize
      # #   @commands = {}
      # # end
      # 
      # def register( name, klass )
      #   @commands ||= {}
      #   @command[ name ] = klass
      # end
      # 
      # # def actions
      # #   return @action_names if @action_names
      # #   @action_names = @commands.keys
      # #   @action_names.sort
      # # end
    end
    
    ## INSTANCE METHODS
    def find_command_matches( cmd_name )
      # len = cmd_name.length
      # command_names.select { |name| name[ 0, len ] == cmd_name }
      # command_names.select { |name| name[ 0...len ] == cmd_name }
      command_names.select { |name| name[ /^#{cmd_name}/ ] }
    end
    
    def command_names
      []
    end
    
    # ##############
    # # FROM RUBYGEMS
    # 
    # def find_command(cmd_name)
    #   possibilities = find_command_possibilities(cmd_name)
    #   if possibilities.size > 1
    #     raise "Ambiguous command #{cmd_name} matches [#{possibilities.join(', ')}]"
    #   end
    #   if possibilities.size < 1
    #     raise "Unknown command #{cmd_name}"
    #   end
    # 
    #   self[possibilities.first]
    # end
    # 
    # def find_command_possibilities(cmd_name)
    #   len = cmd_name.length
    #   self.command_names.select { |n| cmd_name == n[0,len] }
    # end
    # 
    # private
    # 
    # def load_and_instantiate(command_name)
    #   command_name = command_name.to_s
    #   retried = false
    # 
    #   begin
    #     const_name = command_name.capitalize.gsub(/_(.)/) { $1.upcase }
    #     Gem::Commands.const_get("#{const_name}Command").new
    #   rescue NameError
    #     if retried then
    #       raise
    #     else
    #       retried = true
    #       require "rubygems/commands/#{command_name}_command"
    #       retry
    #     end
    #   end
    # end
    # # END
    # #####
  end
end