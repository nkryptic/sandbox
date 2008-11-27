
# require 'workspace/command'

module Workspace
  module CommandManager
    
    ## CLASS METHODS
    class << self
      
      ## PUBLIC CLASS METHODS
      public
      
        attr_accessor :preload
        
        def commands
          return @commands unless @commands.nil?
          @commands = {}
          setup_commands
          @commands
        end

        # returns a list of the command names which match +cmd_name+
        # partial matches are included
        def find_command_matches( cmd_name )
          len = cmd_name.length
          # command_names.select { |name| name[ 0, len ] == cmd_name }
          command_names.select { |name| name[ /^#{cmd_name}/ ] }
        end

        # returns the full list of all command names
        def command_names
          commands.keys.map { |key| key.to_s }.sort
        end

        # return the command matching (exactly) +cmd_name+
        # will load the command if necessary
        def []( cmd_name )
          cmd_name = cmd_name.to_s.downcase
          return nil if cmd_name.empty?
          cmd_name = cmd_name.intern
          return nil if commands[ cmd_name ].nil?
          commands[ cmd_name ] ||= load_command(cmd_name)
        end
      ## END PUBLIC CLASS METHODS


      ## PRIVATE CLASS METHODS
      private

        # populates the command list, by either stubbing each entry
        # or loading it with it's command instance
        def setup_commands
          Workspace.known_commands.each do |cmd_name|
            if @preload
              commands[ cmd_name ] ||= load_command( cmd_name )
            else
              commands[ cmd_name ] ||= false
            end
          end
        end

        # returns a new command instance matching +cmd_name+
        # dynamically loads the class and if it isn't found, it will
        # attempt to load the expected file and retry
        # 
        # will raise exception when file cannot be loaded or after
        # loading the class is still not found
        #
        # converts command name like: 
        #   do_it
        # to: 
        #   Workspace::Commands::DoIt
        # 
        # and the file loaded (if command isn't initially available):
        #   lib/workspace/commands/do_it_command.rb
        def load_command( cmd_name )
          cmd_name = cmd_name.to_s
          retried = false

          begin
            const_name = cmd_name.capitalize.gsub( /_(.)/ ) { $1.upcase }
            Workspace::Commands.const_get("#{const_name}Command").new
          rescue NameError
            if retried then
              raise
            else
              retried = true
              require "workspace/commands/#{cmd_name}"
              retry
            end
          end
        end
      
    end
    ## END CLASS METHODS
    
  end
end