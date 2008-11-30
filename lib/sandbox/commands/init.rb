
# require 'sandbox/command'

class Sandbox::Commands::InitCommand < Sandbox::Command
  
  ## CLASS METHODS
  class << self
  end
  ## END CLASS METHODS
  
  ## PUBLIC INSTANCE METHODS
  public
    def initialize
      opts = { :ruby_install => false, :rubygems_install => false, :dryrun => false }
      super( 'init', "Create a new sandbox at the given path", opts )
    end
    
    def execute!
      # arg = options[ :args ].first
      if options[ :args ].size < 1
        show_help
      elsif options[ :args ].size > 1
        raise Sandbox::Error.new( 'multiple targets specified - only provide one' )
      else
        target = options[ :args ].first
        installer = Sandbox::Installer.new( target )
        installer.populate
      end
    end
    
    def parser_opts
      [
        [ ["-I", '--install-type TYPE', [:virtual,:rubygems,:full], 'Installation type (virtual, rubygems, full)', 'virtual: create sandbox with system ruby and rubygems', 'rubygems: create sandbox with new rubygems and system ruby', 'full: create sandbox with new ruby and rubygems'], Proc.new { |val,opts| opts[ :install_type ] = val } ],
      ]
    end
    
    def usage
      "#{cli_string} PATH"
    end
  
  ## END PUBLIC INSTANCE METHODS
  
  
  ## PRIVATE INSTANCE METHODS
  private
    
  ## END PRIVATE INSTANCE METHODS
  
end