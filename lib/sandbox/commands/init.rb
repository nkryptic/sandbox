
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
        arg = options[ :args ].first
        
        
        # target = get_target( arg )
        # raise Sandbox::SandboxError.new( 'target directory exists' )
        
        # if File.exists?( arg )
        #   raise Sandbox::SandboxError.new( 'target directory exists' )
        # end
        # target = FileUtils.pwd + '/' + arg
        # FileUtils.mkdir_p( target )
      end
    end
    
    def resolve_target( path )
      # abs = path and path[0] == '/'
      unless path.index( '/' ) == 0
        path = File.join( FileUtils.pwd, path )
      end
      if File.exists?( path )
        raise
      end
      base = path
      while base = File.dirname( base )
        if File.directory?( base ) and File.writable?( base )
          break
        elsif File.directory?( base )
          raise
        elsif base == '/'
          raise
        end
      end
      return path
    end
    
    # def parser_opts
    #   []
    # end
  
  ## END PUBLIC INSTANCE METHODS
  
  
  ## PRIVATE INSTANCE METHODS
  private
    
  ## END PRIVATE INSTANCE METHODS
  
end