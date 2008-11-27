$:.unshift(File.dirname(__FILE__)) unless \
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


module Workspace
  
  class << self
    
    # the global list of commands
    def known_commands
      [ :help, :init ]
    end
    
  end
  
  class WorkspaceError < StandardError
    attr_reader :help_str
    def initialize( msg=nil, help_str=nil )
      super msg
      @help_str = help_str
    end
    def message
      value = super
      value if value != self.class.name
    end
  end
  class InWorkspaceError < WorkspaceError
  end
  class UnknownCommand < WorkspaceError
    def initialize( cmd, help_str='workspace --help' )
      msg = "unrecognized command '#{cmd}'"
      super msg, help_str
    end
  end
  class AmbiguousCommand < WorkspaceError
    def initialize( cmd, possibles, help_str='workspace --help' )
      possibles_str = possibles.collect{ |p| "'#{p}'" }.join( ", ")
      msg = "command '#{cmd}' is ambiguous (matches #{possibles_str})"
      super msg, help_str
    end
  end
  class UnknownSwitch < WorkspaceError
    def initialize( switch, help_str='workspace --help' )
      msg = "invalid option #{switch}"
      super msg, help_str
    end
  end
  
end

require 'workspace/version'
# require 'workspace/cli'
require 'workspace/command_manager'
require 'workspace/command'

Workspace.known_commands.each do |cmd|
  require File.dirname( __FILE__ ) + '/workspace/commands/' + cmd.to_s
end
# Dir[ File.dirname( __FILE__ ) + '/workspace/commands/*' ].each do |file|
#   require file
# end
