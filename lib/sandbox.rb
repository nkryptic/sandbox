$:.unshift(File.dirname(__FILE__)) unless \
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


module Sandbox
  
  class << self
    
    # the global list of commands
    def known_commands
      [ :help, :init ].freeze
    end
    
    def verbosity
      @verbosity ||= 0
    end
    
    def increase_verbosity
      @verbosity = verbosity + 1
    end
    
    def decrease_verbosity
      @verbosity = verbosity - 1
    end
    
  end
  
end

require 'sandbox/version'
require 'sandbox/errors'
# require 'sandbox/cli'
require 'sandbox/command_manager'
require 'sandbox/command'

Sandbox.known_commands.each do |cmd|
  require File.dirname( __FILE__ ) + '/sandbox/commands/' + cmd.to_s
end

# Dir[ File.dirname( __FILE__ ) + '/sandbox/commands/*' ].each do |file|
#   require file
# end
