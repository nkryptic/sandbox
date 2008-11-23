
require 'optparse'


module Workspace
  class Command
    
    ## CLASS METHODS
    class << self
    end
    ## END CLASS METHODS
    
    ## PUBLIC INSTANCE METHODS
    def initialize( command, summary=nil, defaults={} )
    end
    
    def process_options!( args, globals_options={} )
    end
    
    # Override to provide command handling.
    def execute!
      raise NotImplementedError, "'execute!' is not implemented by #{self.class.name}"
    end
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      
    ## END PRIVATE INSTANCE METHODS
    
  end
  
  
  # This is where individual Commands will be placed in the namespace
  module Commands; end
  
end