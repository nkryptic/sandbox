
module Sandbox
  module Output
    
    def tell( msg )
      tell_unless_quiet( msg )
    end
    
    def tell_when_verbose( msg )
      puts msg if Sandbox.verbose?
    end
    
    def tell_when_really_verbose( msg )
      puts msg if Sandbox.really_verbose?
    end
    
    def tell_unless_quiet( msg )
      puts msg unless Sandbox.quiet?
    end
    
    def tell_unless_really_quiet( msg )
      puts msg unless Sandbox.really_quiet?
    end
    
  end
end