
require 'workspace/command'

class Workspace::Commands::InitCommand < Workspace::Command
  
  ## CLASS METHODS
  class << self
  end
  ## END CLASS METHODS
  
  ## PUBLIC INSTANCE METHODS
  public
    def initialize
      opts = { :ruby_install => false, :rubygems_install => false, :dryrun => false }
      super( 'init', "Create a new workspace at the given path", opts )
    end
  ## END PUBLIC INSTANCE METHODS
  
  
  ## PRIVATE INSTANCE METHODS
  private
    
  ## END PRIVATE INSTANCE METHODS
  
end