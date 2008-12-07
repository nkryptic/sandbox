
require File.dirname( __FILE__ ) + '/../spec_helper'

describe Sandbox::Installer, "(mocked)" do
  
  before( :each ) do
    Sandbox.instance_eval { instance_variables.each { |v| remove_instance_variable v } }
  end
  
  describe "creating an instance" do
    # initialize( options={} )
    it "should set it's options" do
      opts = { :somewhere => true, :nowhere => false }
      installer = Sandbox::Installer.new( opts )
      installer.options[ :somewhere ].should be_true
      installer.options[ :nowhere ].should be_false
    end
  end
  
  describe "instance" do
    # target
    describe "when target called" do
      it "should validate target directory once" do
        path = '/some/new/target'
        opts = { :target => path }
        @installer = Sandbox::Installer.new( opts )
        @installer.expects( :resolve_target ).with( path ).once.then.returns( path )
        @installer.target.should == path
        @installer.target.should == path
      end
    end

    # populate
    describe "when populate called" do
      it "should call all steps of populate process" do
        @installer = Sandbox::Installer.new
        @installer.stubs( :tell )
        @installer.stubs( :target ).returns( '/tmp/sandbox' )
        @installer.expects( :create_directories )
        @installer.expects( :install_scripts )
        @installer.expects( :install_gemrc )
        @installer.expects( :install_gems )
        @installer.populate
      end
    end

    # create_directories
    describe "when create_directories called" do
      before( :each ) do
        @path = '/some/new/target'
        @installer = Sandbox::Installer.new
        @installer.stubs( :target ).returns( @path )
      end
      it "should create sandbox directory structure" do
        FileUtils.expects( :mkdir_p ).with( @path + '/rubygems/bin' )
        FileUtils.stubs( :ln_s )
        @installer.create_directories
      end
      
      it "should symlink gem bin directory" do
        FileUtils.stubs( :mkdir_p )
        FileUtils.expects( :ln_s ).with( @path + '/rubygems/bin', @path + '/bin' )
        @installer.create_directories
      end
    end

    # install_scripts
    describe "when install_scripts called" do
      before( :each ) do
        @path = '/some/new/target'
        @installer = Sandbox::Installer.new
        @installer.stubs( :target ).returns( @path )
      end
      
      it "should read template file" do
        File.expects( :read ).with( regexp_matches( /templates\/activate_sandbox\.erb/ ) ).returns( '<%= target %>' )
        File.stubs( :open )
        @installer.install_scripts
      end
      
      it "should write out activate script to SANDBOX/bin/activate_sandbox" do
        file = StringIO.new
        File.stubs( :read ).returns( '<%= target %>' )
        File.expects( :open ).with( @path + '/bin/activate_sandbox', 'w' ).yields( file )
        @installer.install_scripts
        file.string.should == @path
      end
    end
    
    # install_gemrc
    describe "when install_gemrc called" do
      before( :each ) do
        @path = '/some/new/target'
        @installer = Sandbox::Installer.new
        @installer.stubs( :target ).returns( @path )
      end
      
      it "should read template file" do
        File.expects( :read ).with( regexp_matches( /templates\/gemrc\.erb/ ) ).returns( '' )
        File.stubs( :open )
        @installer.install_gemrc
      end
      
      it "should write out gemrc to SANDBOX/.gemrc" do
        file = StringIO.new
        File.stubs( :read ).returns( 'gemrc' )
        File.expects( :open ).with( @path + '/.gemrc', 'w' ).yields( file )
        @installer.install_gemrc
        file.string.should == 'gemrc'
      end
    end

    # install_gems
    describe "when install_gems called" do
      before( :each ) do
        @installer = Sandbox::Installer.new( :gems => [ 'mygem' ] )
        @installer.stubs( :setup_sandbox_env )
        @installer.stubs( :restore_sandbox_env )
        @installer.stubs( :tell )
        @installer.stubs( :tell_unless_really_quiet )
      end
      
      # it "should skip install when network is not available" do
      #   Ping.expects( :pingecho ).with( 'gems.rubyforge.org' ).returns( false )
      #   @installer.install_gems.should be_false
      # end
      
      it "should install a good gem" do
        @installer.expects( :shell_out ).with( 'gem install mygem' ).returns( [ true, 'blah' ] )
        @installer.install_gems
      end
      
      it "should gracefully handle a bad gem" do
        @installer.expects( :shell_out ).with( 'gem install mygem' ).returns( [ false, 'blah' ] )
        @installer.expects( :tell_unless_really_quiet ).with( regexp_matches( /failed/ ) )
        @installer.install_gems
      end
    end

    # resolve_target( path )
    describe "when resolve_target called" do
      before( :each ) do
        @path = '/absolute/path/to/parent'
        @installer = Sandbox::Installer.new
        @installer.stubs( :fix_path ).returns( @path )
      end
      
      it "should raise error when it path exists" do
        File.expects( :exists? ).with( @path ).returns( true )
        lambda { @installer.resolve_target( @path ) }.should raise_error( Sandbox::Error )
      end
      
      it "should return path when parent directory passes check_path!" do
        File.expects( :exists? ).with( @path ).returns( false )
        @installer.expects( :check_path! ).with( '/absolute/path/to' ).returns( true )
        @installer.resolve_target( @path ).should == @path
      end
      
      it "should return path when any parent directory passes check_path!" do
        File.expects( :exists? ).with( @path ).returns( false )
        @installer.expects( :check_path! ).with( '/absolute/path/to' ).returns( false )
        @installer.expects( :check_path! ).with( '/absolute/path' ).returns( false )
        @installer.expects( :check_path! ).with( '/absolute' ).returns( true )
        @installer.resolve_target( @path ).should == @path
      end
      
      it "should have emergency safeguard for dirname on root" do
        @installer.stubs( :fix_path ).returns( '/absolute' )
        @installer.expects( :check_path! ).with( '/' ).returns( false )
        lambda { @installer.resolve_target( '/absolute' ) }.should raise_error( RuntimeError )
      end
    end

    # check_path!( path )
    describe "when check_path! called" do
      before( :each ) do
        @path = '/absolute/path/to/parent'
        @installer = Sandbox::Installer.new
      end
      
      it "should raise error when it is not writable" do
        File.expects( :directory? ).with( @path ).returns( true )
        File.expects( :writable? ).with( @path ).returns( false )
        lambda { @installer.check_path!( @path ) }.should raise_error( Sandbox::Error )
      end
      
      it "should raise error when it is not a directory" do
        File.expects( :directory? ).with( @path ).returns( false )
        File.expects( :exists? ).with( @path ).returns( true )
        lambda { @installer.check_path!( @path ) }.should raise_error( Sandbox::Error )
      end
      
      it "should return false when it doesn't exist" do
        File.expects( :directory? ).with( @path ).returns( false )
        File.expects( :exists? ).with( @path ).returns( false )
        @installer.check_path!( @path ).should be_false
      end
      
      it "should return true when it can be created" do
        File.expects( :directory? ).with( @path ).returns( true )
        File.expects( :writable? ).with( @path ).returns( true )
        @installer.check_path!( @path ).should == true
      end
    end

    # fix_path( path )
    describe "when fix_path called" do
      it "should not change absolute path" do
        path = '/absolute/path/to/target'
        @installer = Sandbox::Installer.new
        @installer.fix_path( path ).should == path
      end
      
      it "should make relative into absolute path" do
        abs_path = '/absolute/working/directory'
        path = 'relative/path/to/target'
        FileUtils.expects( :pwd ).returns( abs_path )
        @installer = Sandbox::Installer.new
        @installer.fix_path( path ).should == abs_path + '/' + path
      end
    end
    
    # shell_out( cmd )
    describe "when shell_out called" do
      it "should record true when successful" do
        @installer = Sandbox::Installer.new
        result = @installer.shell_out( 'true' )
        result.first.should be_true
      end
      
      it "should record false when unsuccessful" do
        @installer = Sandbox::Installer.new
        result = @installer.shell_out( 'false' )
        result.first.should_not be_true
      end
      
      it "should record std output" do
        @installer = Sandbox::Installer.new
        result = @installer.shell_out( 'ls -d /' )
        result.last.chomp.should == '/'
      end
      
      it "should ignore std error" do
        @installer = Sandbox::Installer.new
        result = @installer.shell_out( 'ls -d / 1>/dev/null' )
        result.last.chomp.should == ''
      end
    end
    
    describe "setup and restore sandbox env called" do
      it "should set and restore the environment" do
        orig_home = ENV[ 'HOME' ]
        orig_gem_home = ENV[ 'GEM_HOME' ]
        orig_gem_path = ENV[ 'GEM_PATH' ]
        @installer = Sandbox::Installer.new
        @installer.stubs( :target ).returns( 'dummypath' )
        
        @installer.setup_sandbox_env
        ENV[ 'HOME' ].should == 'dummypath'
        ENV[ 'GEM_HOME' ].should == 'dummypath/rubygems'
        ENV[ 'GEM_PATH' ].should == 'dummypath/rubygems'
        @installer.restore_sandbox_env
        ENV[ 'HOME' ].should == orig_home
        ENV[ 'GEM_HOME' ].should == orig_gem_home
        ENV[ 'GEM_PATH' ].should == orig_gem_path
      end
    end
  end
end

describe Sandbox::Installer, "(using tmpdir)" do
  def tmppath() File.join( Dir.tmpdir, "sandbox_testing" ) end
  def rmtmppath() FileUtils.rm_rf( tmppath ) end
  def mktmppath() FileUtils.mkdir_p( tmppath ) end

  def in_dir( dir = tmppath )
    old_pwd = Dir.pwd
    begin
      Dir.chdir( dir )
      yield
    ensure
      Dir.chdir( old_pwd )
    end
  end
  
  before( :each ) do
    mktmppath
  end
  
  after( :each ) do
    rmtmppath
  end
  
  it "should create target directory structure" do
    target = tmppath + '/target'
    @installer = Sandbox::Installer.new( :target => target )
    @installer.create_directories
    File.directory?( target + '/rubygems/bin' ).should be_true
    File.symlink?( target + '/bin' ).should be_true
  end
end


  