
# require 'erb'

module Sandbox
  
  class Installer
    
    ## CLASS METHODS
    class << self
    end
    ## END CLASS METHODS

    ## PUBLIC INSTANCE METHODS
    public
    
    # def initialize( options={} )
    # end
    # 
    # def install_scripts
    #   template = File.read( File.dirname( __FILE__ ) + '/templates/activate.rubygems.erb' )
    #   script = ERB.new( template )
    #   output = script.result( binding )
    # end
    # 
    # def resolve_target( path )
    #   path = fix_path( path )
    #   raise if File.exists?( path )
    #   
    #   base = path
    #   while base = File.dirname( base )
    #     if File.directory?( base ) and File.writable?( base )
    #       break
    #     elsif File.directory?( base )
    #       raise
    #     elsif base == '/'
    #       raise
    #     end
    #   end
    #   return path
    # end
    # 
    # def fix_path( path )
    #   unless path.index( '/' ) == 0
    #     path = File.join( FileUtils.pwd, path )
    #   end
    #   path
    # end

    ## END PUBLIC INSTANCE METHODS


    ## PRIVATE INSTANCE METHODS
    private

    ## END PRIVATE INSTANCE METHODS
  
  end
  
end