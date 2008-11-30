
require 'erb'

module Sandbox
  
  class Installer
    
    ## CLASS METHODS
    class << self
    end
    ## END CLASS METHODS

    ## PUBLIC INSTANCE METHODS
    public
      def initialize( target_path )
        @target_path = resolve_target( target_path )
      end
      
      def populate
        install_type = Sandbox.config.install_type
        
        if install_type == :full
          install_ruby
        end
        
        if install_type == :full or install_type == :rubygems
          install_rubygems
        end
        
        install_scripts
      end
      
      def install_scripts
        template = File.read( File.dirname( __FILE__ ) + '/templates/activate.rubygems.erb' )
        script = ERB.new( template )
        output = script.result( binding )
      end
      
      def resolve_target( path )
        path = fix_path( path )
        raise if File.exists?( path )
        
        base = path
        while base = File.dirname( base )
          if File.exists?( base )
            if File.directory?( base ) and File.writable?( base )
              break
            else
              raise
            end
          elsif base == '/'
            break
          end
        end
        return path
      end
      
      def fix_path( path )
        unless path.index( '/' ) == 0
          path = File.join( FileUtils.pwd, path )
        end
        path
      end
      
    # def run
      # if SourceDownloader.needed?
      #   SourceDownloader.run
      # end
      # 
      # if SourceExtractor.needed?
      #   SourceExtractor.run
      # end
      # 
      # create_target( target )
      # 
      # if SourceBuilder.needed?
      #   SourceBuilder.run
      # end
      # 
      # Initializer.run
      
      # case install_type
      #   when :rubygems
      #     # get rubygems version to install
      #     # check cache to see if already exists
      #     # if no
      #     #   download rubygems to cache
      #     # create extraction dir (remove first if exists)
      #     # cd to extraction dir
      #     # extract rubygems from cache
      #     # cd to rubygems dir
      #     # set environment variables
      #     # use system ruby to build rubygems
      #   when :full
      # else # :virtual
      # end
    # end

    ## END PUBLIC INSTANCE METHODS


    ## PRIVATE INSTANCE METHODS
    private
      
    ## END PRIVATE INSTANCE METHODS
    
  end
  
end

