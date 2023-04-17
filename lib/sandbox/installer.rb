
require 'fileutils'
# require 'ping'
# require 'timeout'
require 'erb'

module Sandbox
  
  class Installer
    include Sandbox::Output
    extend Sandbox::Output
    
    ## CLASS METHODS
    class << self
    end
    ## END CLASS METHODS
    
    attr_accessor :options
    
    ## PUBLIC INSTANCE METHODS
    public
    
    def initialize( options={} )
      @options = options.dup
      @target = nil
    end
    
    def target
      return @target unless @target.nil?
      @target = resolve_target( options[ :target ] )
    end
    
    def populate
      tell( "creating sandbox at: #{target}" )
      create_directories
      tell( "installing activation script" )
      install_scripts
      tell( "installing .gemrc" )
      install_gemrc
      tell( "installing gems" )
      install_gems
    end
    
    def create_directories
      bin = File.join( target, 'bin' )
      gembin = File.join( target, 'rubygems', 'bin' )
      
      # mkdir /path/to/sandbox/
      # mkdir /path/to/sandbox/rubygems
      # mkdir /path/to/sandbox/rubygems/bin
      FileUtils.mkdir_p( gembin )
      
      # ln -s /path/to/sandbox/rubygems/bin /path/to/sandbox/bin
      # symlink the bin directory, because when gems are installed, binaries are
      # installed in GEM_HOME/bin
      FileUtils.ln_s( gembin, bin )
    end
    
    def install_gemrc
      filename = File.join( target, '.gemrc' )
      template = File.read( File.dirname( __FILE__ ) + '/templates/gemrc.erb' )
      script = ERB.new( template )
      output = script.result( binding )
      File.open( filename, 'w' ) do |f|
        f.write output
      end
    end
    
    def install_scripts
      filename = File.join( target, 'bin', 'activate_sandbox' )
      template = File.read( File.dirname( __FILE__ ) + '/templates/activate_sandbox.erb' )
      script = ERB.new( template )
      output = script.result( binding )
      File.open( filename, 'w' ) do |f|
        f.write output
      end
    end
    
    def install_gems
      # gem = `which gem`.chomp
      # return if gem.empty?
      gems = options[ :gems ] || []
      if gems.size == 0
        tell( "  nothing to install" )
        return
      end
      
      begin
        setup_sandbox_env
        gems.each do |gem|
          tell_unless_really_quiet( "  gem: #{gem}" )
          cmd = "gem install #{gem}"
          # cmd = cmd + ' -V' if Sandbox.really_verbose?
          status, output = shell_out( cmd )
          unless status
            tell_unless_really_quiet( "    failed to install gem: #{gem}" )
          end
        end
      ensure
        restore_sandbox_env
      end
    end
    
    def shell_out( cmd )
      # err_capture = Sandbox.really_verbose? '2>&1' : '2>/dev/null'
      # out = `#{cmd} #{err_capture}`
      out = `#{cmd} 2>/dev/null`
      result = $?.exitstatus == 0
      [ result, out ]
    end
    
    def setup_sandbox_env
      @old_env = Hash[ *ENV.select { |k,v| ['HOME','GEM_HOME','GEM_PATH'].include?( k ) }.flatten ]
      # @old_env = {}
      # @old_env[ 'HOME' ]      = ENV[ 'HOME' ]
      # @old_env[ 'GEM_HOME' ]  = ENV[ 'GEM_HOME' ]
      # @old_env[ 'GEM_PATH' ]  = ENV[ 'GEM_PATH' ]
      
      ENV[ 'HOME' ]     = target
      ENV[ 'GEM_HOME' ] = "#{target}/rubygems"
      ENV[ 'GEM_PATH' ] = "#{target}/rubygems"
    end
    
    def restore_sandbox_env
      # ENV.update( @old_env )
      ENV[ 'HOME' ]     = @old_env[ 'HOME' ]
      ENV[ 'GEM_HOME' ] = @old_env[ 'GEM_HOME' ]
      ENV[ 'GEM_PATH' ] = @old_env[ 'GEM_PATH' ]
    end
    
    def resolve_target( path )
      # should consider replacing with 'pathname' => Pathname.new( path )
      path = fix_path( path )
      if File.exist?( path )
        raise Sandbox::Error, "target '#{path}' exists"
      end
      
      base = path
      while base = File.dirname( base )
        if check_path!( base )
          break
        elsif base == '/'
          raise "something is seriously wrong; we should never get here"
        end
      end
      return path
    end
    
    def check_path!( path )
      if File.directory?( path )
        if File.writable?( path )
          return true
        else
          raise Sandbox::Error, "path '#{path}' has a permission problem"
        end
      elsif File.exist?( path )
        raise Sandbox::Error, "path '#{path}' is not a directory"
      end
      false
    end
    
    def fix_path( path )
      unless path.index( '/' ) == 0
        path = File.join( FileUtils.pwd, path )
      end
      path
    end

    ## END PUBLIC INSTANCE METHODS


    ## PRIVATE INSTANCE METHODS
    private

    ## END PRIVATE INSTANCE METHODS
  
  end
  
end