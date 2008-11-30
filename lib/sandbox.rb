$:.unshift(File.dirname(__FILE__)) unless \
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


module Sandbox
  
  class << self
    
    def verbosity
      @verbosity ||= 0
    end
    
    def increase_verbosity
      @verbosity = verbosity + 1
    end
    
    def decrease_verbosity
      @verbosity = verbosity - 1
    end
    
    def quiet?() verbosity < 0 end
    def really_quiet?() verbosity < 1 end
    def verbose?() verbosity > 0 end
    def really_verbose?() verbosity > 1 end
    
    def config
      @config ||= Sandbox::Config.new
    end
    
  end
  
end

require 'sandbox/version'
require 'sandbox/errors'
require 'sandbox/config'
require 'sandbox/installer'

