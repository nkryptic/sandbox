
module Sandbox
  
  class Error < StandardError
    
    def initialize( msg=nil )
      super msg
    end
    
    def message
      out = []
      value = super
      out << "Sandbox error: #{value}"
      out.concat( backtrace.collect { |bt| "    #{bt}" } ) if Sandbox.really_verbose?
      out.join( "\n" )
    end
    
  end
  
  class LoadedSandboxError < Sandbox::Error
    
    def initialize( msg=nil )
      msg ||= "You cannot run sandbox from a loaded sandbox environment"
    end
    
  end
  
  class ParseError < Sandbox::Error
    
    def initialize( reason=nil, args=[] )
      if args.is_a?( Array ) and args.size > 0
        msg = "#{reason} => #{args.join( ' ' )}"
      elsif args.is_a?( String ) and args.length > 0
        msg = "#{reason} => #{args}"
      else
        msg = reason
      end
      super msg
    end
    
  end
  
end