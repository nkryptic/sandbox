module Workspace
  class Command
    
    ## CLASS METHODS
    class << self
      # def inherited( klass )
      #   register( klass )
      # end
    end
    
    ## INSTANCE METHODS
    def initialize( command, summary=nil, defaults={} )
    end
    
    def parse_options!( args )
    end
    
  end
end