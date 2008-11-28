
module Sandbox
  
  class Error < StandardError
    attr_reader :help_str
    def initialize( msg=nil, help_str=nil )
      super msg
      @help_str = help_str
    end
    def message
      out = []
      value = super
      # value if value != self.class.name
      out << "Error: #{value}"
      out << "see '#{@help_str}'" if @help_str
      out.join( "\n" )
    end
  end
  
  class LoadedSandboxError < Sandbox::Error
    def initialize( msg=nil, help_str=nil )
      msg ||= "You cannot run sandbox from a loaded sandbox environment"
      super msg, help_str
    end
  end
  
  class ParseError < Sandbox::Error
    def initialize( reason=nil, args=[], help_str=nil )
      if args.is_a?( Array ) and args.size > 0
        msg = "#{reason} => #{args.join( ' ' )}"
      elsif args.is_a?( String ) and args.length > 0
        msg = "#{reason} => #{args}"
      else
        msg = reason
      end
      super msg, help_str
    end
  end
  
  class UnknownCommandError < ParseError
    def initialize( cmd, help_str='sandbox --help' )
      msg = "unrecognized command"
      super msg, cmd, help_str
    end
  end
  
  class AmbiguousCommandError < ParseError
    def initialize( cmd, possibles, help_str='sandbox --help' )
      msg = "command '#{cmd}' is ambiguous"
      super msg, possibles, help_str
    end
  end
  
  class UnknownSwitchError < ParseError
    def initialize( switch, help_str='sandbox --help' )
      msg = "invalid option"
      super msg, switch, help_str
    end
  end
  
  # class UnknownCommandError < Sandbox::Error
  #   def initialize( cmd, help_str='sandbox --help' )
  #     msg = "unrecognized command '#{cmd}'"
  #     super msg, help_str
  #   end
  # end
  # 
  # class AmbiguousCommandError < Sandbox::Error
  #   def initialize( cmd, possibles, help_str='sandbox --help' )
  #     possibles_str = possibles.collect{ |p| "'#{p}'" }.join( ", ")
  #     msg = "command '#{cmd}' is ambiguous (matches #{possibles_str})"
  #     super msg, help_str
  #   end
  # end
  # 
  # class UnknownSwitchError < Sandbox::Error
  #   def initialize( switch, help_str='sandbox --help' )
  #     msg = "invalid option #{switch}"
  #     super msg, help_str
  #   end
  # end
  
end