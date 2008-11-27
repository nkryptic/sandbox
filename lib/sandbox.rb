$:.unshift(File.dirname(__FILE__)) unless \
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


module Sandbox
  
  class << self
    
    # the global list of commands
    def known_commands
      [ :help, :init ]
    end
    
  end
  
  class SandboxError < StandardError
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
  class InSandboxError < SandboxError
  end
  class UnknownCommand < SandboxError
    def initialize( cmd, help_str='sandbox --help' )
      msg = "unrecognized command '#{cmd}'"
      super msg, help_str
    end
  end
  class AmbiguousCommand < SandboxError
    def initialize( cmd, possibles, help_str='sandbox --help' )
      possibles_str = possibles.collect{ |p| "'#{p}'" }.join( ", ")
      msg = "command '#{cmd}' is ambiguous (matches #{possibles_str})"
      super msg, help_str
    end
  end
  class UnknownSwitch < SandboxError
    def initialize( switch, help_str='sandbox --help' )
      msg = "invalid option #{switch}"
      super msg, help_str
    end
  end
  
end

require 'sandbox/version'
# require 'sandbox/cli'
require 'sandbox/command_manager'
require 'sandbox/command'

Sandbox.known_commands.each do |cmd|
  require File.dirname( __FILE__ ) + '/sandbox/commands/' + cmd.to_s
end
# Dir[ File.dirname( __FILE__ ) + '/sandbox/commands/*' ].each do |file|
#   require file
# end
