
module Sandbox
  
  class Config
    
    CONFIG_FILE = 'config'
    
    ## CLASS METHODS
    class << self
      
      def user_home
        @user_home ||= find_user_home
      end
      
      def find_user_home
        return ENV[ 'HOME' ] if ENV[ 'HOME' ]

        begin
          File.expand_path( "~" )
        rescue
          "/"
        end
      end
      
      def default_config_dir
        File.join( user_home, '.sandbox' )
      end
      
      def default_config_file
        File.join( default_config_dir, 'config' )
      end
      
    end
    ## END CLASS METHODS

    ## PUBLIC INSTANCE METHODS
    attr_reader :install_type, :ruby_to_install, :rubygems_to_install
    
    public
      def initialize( opts={} )
        @install_type = :virtual
        @ruby_to_install = 'ruby-1.8.6-p287'
        @rubygems_to_install = 'rubygems-1.3.1'
        @config_file = opts[ :config_file ]
        user_config = load_file( config_file )
        @directory = user_config[ :directory ]
      end
      
      def config_file
        @config_file ||= Config.default_config_file
      end
      
      def directory
        @directory ||= Config.default_config_dir
      end
      
      def load_file( filename )
        data = {}
        begin
          data = YAML.load( File.read( filename ) ) if filename and File.exist?( filename )
        rescue ArgumentError
          # warn "Failed to load #{config_file_name}"
          warn "Failed to load #{filename}"
        rescue Errno::EACCES
          # warn "Failed to load #{config_file_name} due to permissions problem."
          warn "Failed to load #{filename} due to permissions problem."
        end
        
        return data
      end

    ## END PUBLIC INSTANCE METHODS


    ## PRIVATE INSTANCE METHODS
    private

    ## END PRIVATE INSTANCE METHODS
    
  end
  
end

