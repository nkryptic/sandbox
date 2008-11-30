
require File.dirname( __FILE__ ) + '/../spec_helper.rb'

describe Sandbox::Installer do
  
  # before( :each ) do
  #   
  # end
  
  # it "should require a path on creation" do
  #   path = '/'
  #   installer = Sandbox::Installer.new( path )
  # end
  
  describe "instance" do
    
    before( :all ) do
      @tmpdir = Dir.tmpdir
    end

    before( :each ) do
      @installer = Sandbox::Installer.new( @tmpdir + '/test1' )
    end
    
    describe "when populate called" do
      
      before( :each ) do
        @config = mock( "Config" )
        Sandbox.stubs( :config ).returns( @config )
        @installer.stubs( :resolve_target )
      end
      
      describe "for :virtual install" do
        
        it "should call install_scripts" do
          @config.stubs( :install_type ).returns( :virtual )
          @installer.expects( :install_scripts )
          @installer.populate
        end
        
      end
      
      describe "for :rubygems install" do
        
        it "should call install_rubygems and install_scripts" do
          @config.stubs( :install_type ).returns( :rubygems )
          @installer.expects( :install_rubygems )
          @installer.expects( :install_scripts )
          @installer.populate
        end
        
      end
      
      describe "for :full install" do
        
        it "should call install_ruby, install_rubygems and install_scripts" do
          @config.stubs( :install_type ).returns( :full )
          @installer.expects( :install_ruby )
          @installer.expects( :install_rubygems )
          @installer.expects( :install_scripts )
          @installer.populate
        end
        
      end
      
    end
    
    describe "when install_scripts called" do
      
      it "should install properly configured activate script" do
        @installer.install_scripts
      end
      
    end
    
  end
  
  describe "when resolve_target called" do

    before( :all ) do
      @abs_dir = '/path/to/new'
      @abs_target = @abs_dir + '/target'
      @rel_target = 'target'
      @deep_rel_dir = 'path/to/new'
      @deep_rel_target = @deep_rel_dir + '/' + 'target'
      @abs_deep_target = @abs_dir + '/' + @deep_rel_target
    end
    
    before( :each ) do
      Sandbox::Installer.any_instance.stubs( :initialize )
      @installer = Sandbox::Installer.new( '/' )
    end

    describe "with relative path" do

      it "should raise error when target exists" do
        FileUtils.expects( :pwd ).returns( @abs_dir )
        File.expects( :exists? ).with( @abs_target ).returns( true )
        lambda { @installer.resolve_target( @rel_target ) }.should raise_error
      end
      
      it "should raise error when parent of target is not a directory" do
        FileUtils.expects( :pwd ).returns( @abs_dir )
        # File.expects( :directory? ).with( @abs_dir ).returns( true )
        File.expects( :exists? ).with( @abs_target ).returns( false )
        File.expects( :exists? ).with( @abs_dir ).returns( true )
        File.expects( :directory? ).with( @abs_dir ).returns( false )
        lambda { @installer.resolve_target( @rel_target ) }.should raise_error
      end

      it "should raise error when parent of target is not writable" do
        FileUtils.expects( :pwd ).returns( @abs_dir )
        # File.expects( :directory? ).with( @abs_dir ).returns( true )
        File.expects( :exists? ).with( @abs_target ).returns( false )
        File.expects( :exists? ).with( @abs_dir ).returns( true )
        File.expects( :directory? ).with( @abs_dir ).returns( true )
        File.expects( :writable? ).with( @abs_dir ).returns( false )
        lambda { @installer.resolve_target( @rel_target ) }.should raise_error
      end

      it "should raise error when point on path up to target is not writable" do
        # File.expects( :directory? ).with( @abs_dir ).returns( true )
        FileUtils.expects( :pwd ).returns( @abs_dir )
        File.expects( :exists? ).with( @abs_deep_target ).returns( false )
        File.expects( :exists? ).with( '/path/to/new/path/to/new' ).returns( false )
        File.expects( :exists? ).with( '/path/to/new/path/to' ).returns( true )
        File.expects( :directory? ).with( '/path/to/new/path/to' ).returns( true )
        File.expects( :writable? ).with( '/path/to/new/path/to' ).returns( false )
        lambda { @installer.resolve_target( @deep_rel_target ) }.should raise_error
      end

      it "should return the absolute path" do
        FileUtils.expects( :pwd ).returns( @abs_dir )
        File.expects( :exists? ).with( @abs_target ).returns( false )
        File.expects( :exists? ).with( @abs_dir ).returns( true )
        File.expects( :directory? ).with( @abs_dir ).returns( true )
        File.expects( :writable? ).with( @abs_dir ).returns( true )
        target = @installer.resolve_target( @rel_target )
        target.should == @abs_target
      end

    end

    describe "with absolute path" do

      it "should raise error when target exists" do
        File.expects( :exists? ).with( @abs_target ).returns( true )
        lambda { @installer.resolve_target( @abs_target ) }.should raise_error
      end

      it "should raise error when point on path up to target is not writable" do
        # File.expects( :directory? ).with( @abs_dir ).returns( true )
        File.expects( :exists? ).with( @abs_target ).returns( false )
        File.expects( :exists? ).with( @abs_dir ).returns( false )
        File.expects( :exists? ).with( '/path/to' ).returns( false )
        File.expects( :exists? ).with( '/path' ).returns( true )
        File.expects( :directory? ).with( '/path' ).returns( true )
        File.expects( :writable? ).with( '/path' ).returns( false )
        lambda { @installer.resolve_target( @abs_target ) }.should raise_error
      end

      it "should return the absolute path" do
        File.expects( :exists? ).with( @abs_target ).returns( false )
        File.expects( :exists? ).with( @abs_dir ).returns( true )
        File.expects( :directory? ).with( @abs_dir ).returns( true )
        File.expects( :writable? ).with( @abs_dir ).returns( true )
        target = @installer.resolve_target( @abs_target )
        target.should == @abs_target
      end

    end

  end
  

end

