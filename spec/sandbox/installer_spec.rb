
require File.dirname( __FILE__ ) + '/../spec_helper'

describe Sandbox::Installer do
  
  # describe "when resolve_target called" do
  # 
  #   before( :all ) do
  #     @abs_dir = '/path/to/new'
  #     @abs_target = @abs_dir + '/target'
  #     @rel_target = 'target'
  #     @deep_rel_dir = 'path/to/new'
  #     @deep_rel_target = @deep_rel_dir + '/' + 'target'
  #     @abs_deep_target = @abs_dir + '/' + @deep_rel_target
  #   end
  #   
  #   before( :each ) do
  #     @installer = Sandbox::Installer.new
  #   end
  # 
  #   describe "with relative path" do
  # 
  #     it "should raise error when target exists" do
  #       FileUtils.expects( :pwd ).returns( @abs_dir )
  #       File.expects( :exists? ).with( @abs_target ).returns( true )
  #       lambda { @installer.resolve_target( @rel_target ) }.should raise_error
  #     end
  #     
  #     it "should raise error when parent of target is not a directory" do
  #       FileUtils.expects( :pwd ).returns( @abs_dir )
  #       # File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       File.expects( :exists? ).with( @abs_target ).returns( false )
  #       File.expects( :exists? ).with( @abs_dir ).returns( true )
  #       File.expects( :directory? ).with( @abs_dir ).returns( false )
  #       lambda { @installer.resolve_target( @rel_target ) }.should raise_error
  #     end
  # 
  #     it "should raise error when parent of target is not writable" do
  #       FileUtils.expects( :pwd ).returns( @abs_dir )
  #       # File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       File.expects( :exists? ).with( @abs_target ).returns( false )
  #       File.expects( :exists? ).with( @abs_dir ).returns( true )
  #       File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       File.expects( :writable? ).with( @abs_dir ).returns( false )
  #       lambda { @installer.resolve_target( @rel_target ) }.should raise_error
  #     end
  # 
  #     it "should raise error when point on path up to target is not writable" do
  #       # File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       FileUtils.expects( :pwd ).returns( @abs_dir )
  #       File.expects( :exists? ).with( @abs_deep_target ).returns( false )
  #       File.expects( :exists? ).with( '/path/to/new/path/to/new' ).returns( false )
  #       File.expects( :exists? ).with( '/path/to/new/path/to' ).returns( true )
  #       File.expects( :directory? ).with( '/path/to/new/path/to' ).returns( true )
  #       File.expects( :writable? ).with( '/path/to/new/path/to' ).returns( false )
  #       lambda { @installer.resolve_target( @deep_rel_target ) }.should raise_error
  #     end
  # 
  #     it "should return the absolute path" do
  #       FileUtils.expects( :pwd ).returns( @abs_dir )
  #       File.expects( :exists? ).with( @abs_target ).returns( false )
  #       File.expects( :exists? ).with( @abs_dir ).returns( true )
  #       File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       File.expects( :writable? ).with( @abs_dir ).returns( true )
  #       target = @installer.resolve_target( @rel_target )
  #       target.should == @abs_target
  #     end
  # 
  #   end
  # 
  #   describe "with absolute path" do
  # 
  #     it "should raise error when target exists" do
  #       File.expects( :exists? ).with( @abs_target ).returns( true )
  #       lambda { @installer.resolve_target( @abs_target ) }.should raise_error
  #     end
  # 
  #     it "should raise error when point on path up to target is not writable" do
  #       # File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       File.expects( :exists? ).with( @abs_target ).returns( false )
  #       File.expects( :exists? ).with( @abs_dir ).returns( false )
  #       File.expects( :exists? ).with( '/path/to' ).returns( false )
  #       File.expects( :exists? ).with( '/path' ).returns( true )
  #       File.expects( :directory? ).with( '/path' ).returns( true )
  #       File.expects( :writable? ).with( '/path' ).returns( false )
  #       lambda { @installer.resolve_target( @abs_target ) }.should raise_error
  #     end
  # 
  #     it "should return the absolute path" do
  #       File.expects( :exists? ).with( @abs_target ).returns( false )
  #       File.expects( :exists? ).with( @abs_dir ).returns( true )
  #       File.expects( :directory? ).with( @abs_dir ).returns( true )
  #       File.expects( :writable? ).with( @abs_dir ).returns( true )
  #       target = @installer.resolve_target( @abs_target )
  #       target.should == @abs_target
  #     end
  # 
  #   end
  # 
  # end
  
end

# describe Sandbox::Commands::InitCommand, 'instance' do
#     
#   # before( :all ) do
#   #   @abs_dir = '/path/to/new'
#   #   @abs_target = @abs_dir + '/target'
#   #   @rel_target = 'target'
#   #   @deep_rel_dir = 'path/to/new'
#   #   @deep_rel_target = @deep_rel_dir + 'target'
#   # end
#   
#   before( :each ) do
#     @cmd = Sandbox::Commands::InitCommand.new
#   end
#   
#   it "should set it's name and summary when calling 'new'" do
#     @cmd.name.should == 'init'
#     @cmd.summary.should =~ /Create a new sandbox/
#   end
#   
#   it "should set default options" do
#     @cmd.options[ :ruby_install ].should be_false
#     @cmd.options[ :rubygems_install ].should be_false
#     @cmd.options[ :dryrun ].should be_false
#   end
#   
#   describe "when process_options! called" do
#     
#     it "should not process target path" do
#       args = [ '/path/to/new/sandbox' ]
#       @cmd.process_options!( args )
#       @cmd.options[ :args ].should == args
#     end
#     
#   end
#   
#   describe "when execute! called" do
#     
#     it "should show it's help when no args passed" do
#       @cmd.options[ :args ] = []
#       @cmd.expects( :show_help )
#       @cmd.execute!
#     end
#     
#     it "should fail with more than one argument left over" do
#       @cmd.options[ :args ] = [ '/path/to/new/sandbox', '/path/to/new/sandbox2' ]
#       @cmd.expects( :raise )
#       @cmd.execute!
#     end
#     
#     # it "should raise error when get_target returns nil" do
#     #   @cmd.options[ :args ] = [ @abs_target ]
#     #   @cmd.expects( :get_target ).with( @abs_target ).returns( nil )
#     #   lambda { @cmd.execute! }.should raise_error( Sandbox::SandboxError ) { |error| error.message.should =~ /target directory exists/ }
#     # end
#     
#     # it "should expand path from current directory with non-absolute target" do
#     #   File.expects( :exists? ).with( @rel_target ).returns( false )
#     #   FileUtils.expects( :pwd ).returns( @abs_dir )
#     #   FileUtils.expects( :mkdir_p ).with( @abs_target )
#     #   @cmd.options[ :args ] = [ @rel_target ]
#     #   @cmd.execute!
#     # end
#     # 
#     # it "should fail when target exists" do
#     #   # File.expects( :directory? ).with( dirpath ).returns( true )
#     #   File.expects( :exists? ).with( @abs_target ).returns( true )
#     #   @cmd.options[ :args ] = [ @abs_target ]
#     #   @cmd.expects( :raise )
#     #   @cmd.execute!
#     # end
#     
#     # it "should fail when base path up target is not writable"
#     
#     it "should create all directories for target as needed"
#     
#   end
#   
#   describe "when resolve_target called" do
#     
#     before( :all ) do
#       @abs_dir = '/path/to/new'
#       @abs_target = @abs_dir + '/target'
#       @rel_target = 'target'
#       @deep_rel_dir = 'path/to/new'
#       @deep_rel_target = @deep_rel_dir + '/' + 'target'
#       @abs_deep_target = @abs_dir + '/' + @deep_rel_target
#     end
#     
#     describe "with relative path" do
#       
#       it "should raise error when target exists" do
#         FileUtils.expects( :pwd ).returns( @abs_dir )
#         File.expects( :exists? ).with( @abs_target ).returns( true )
#         lambda { @cmd.resolve_target( @rel_target ) }.should raise_error
#       end
#       
#       it "should raise error when parent of target is not writable" do
#         FileUtils.expects( :pwd ).returns( @abs_dir )
#         # File.expects( :directory? ).with( @abs_dir ).returns( true )
#         File.expects( :exists? ).with( @abs_target ).returns( false )
#         File.expects( :directory? ).with( @abs_dir ).returns( true )
#         File.expects( :writable? ).with( @abs_dir ).returns( false )
#         lambda { @cmd.resolve_target( @rel_target ) }.should raise_error
#       end
#       
#       it "should raise error when point on path up to target is not writable" do
#         # File.expects( :directory? ).with( @abs_dir ).returns( true )
#         FileUtils.expects( :pwd ).returns( @abs_dir )
#         File.expects( :exists? ).with( @abs_deep_target ).returns( false )
#         File.expects( :directory? ).with( '/path/to/new/path/to/new' ).returns( false ).times(2)
#         File.expects( :directory? ).with( '/path/to/new/path/to' ).returns( true )
#         File.expects( :writable? ).with( '/path/to/new/path/to' ).returns( false )
#         lambda { @cmd.resolve_target( @deep_rel_target ) }.should raise_error
#       end
#       
#       it "should return the absolute path" do
#         FileUtils.expects( :pwd ).returns( @abs_dir )
#         File.expects( :exists? ).with( @abs_target ).returns( false )
#         File.expects( :directory? ).with( @abs_dir ).returns( true )
#         File.expects( :writable? ).with( @abs_dir ).returns( true )
#         target = @cmd.resolve_target( @rel_target )
#         target.should == @abs_target
#       end
#       
#     end
#     
#     describe "with absolute path" do
#       
#       it "should raise error when target exists" do
#         File.expects( :exists? ).with( @abs_target ).returns( true )
#         lambda { @cmd.resolve_target( @abs_target ) }.should raise_error
#       end
#       
#       it "should raise error when point on path up to target is not writable" do
#         # File.expects( :directory? ).with( @abs_dir ).returns( true )
#         File.expects( :exists? ).with( @abs_target ).returns( false )
#         File.expects( :directory? ).with( @abs_dir ).returns( false ).times(2)
#         File.expects( :directory? ).with( '/path/to' ).returns( false ).times(2)
#         File.expects( :directory? ).with( '/path' ).returns( true )
#         File.expects( :writable? ).with( '/path' ).returns( false )
#         lambda { @cmd.resolve_target( @abs_target ) }.should raise_error
#       end
#       
#       it "should return the absolute path" do
#         File.expects( :exists? ).with( @abs_target ).returns( false )
#         File.expects( :directory? ).with( @abs_dir ).returns( true )
#         File.expects( :writable? ).with( @abs_dir ).returns( true )
#         target = @cmd.resolve_target( @abs_target )
#         target.should == @abs_target
#       end
#       
#     end
#     
#   end
#   
#   it "should create directory $HOME/.sandbox"
#   it "should create directory for target"
#   it "should create entire path for target"
#   it "should not create target until it is needed"
#   
#   
#   # it "should load configuration"
#   # it "should merge loaded configuration with defaults or options???" 
#   # it "should download ruby"
#   # it "should look in cache for it first"
#   # it "should download rubygems"
#   # it "should look in cache for it first"
#   # it "should unpackage downloads"
#   # it "should look in cache for it first"
#   # it "should create sandbox directory structure"
#   # it "should build products into sandbox"
#   # it "should setup needed scripts in SANDBOX/bin"
#   # it "should validate target directory"
#   # it "should symlink gem command"
#   # it "should handle install of additional gems"
#   # it "should cache downloads in userdir?"
#   
#   # init:
#   #   get ruby version to install
#   #   get cache location
#   #   get target location
#   #   create target location
#   #     bin, etc, lib, rubygems
#   #   change to tmp dir
#   #   create new Lookup to get download url for ruby
#   #   create new Downloader for ruby tarball and store in cache
#   #   create new Extractor for ruby tarball and extract to tmp
#   #   change to ruby directory
#   #   create new Builder for ruby
#   #     configure --prefix target
#   #     make
#   #     make install
#   #   change to tmp dir
#   #   clean up ruby dir?
#   #   
#   #   
#   #   same for rubygems
#   #     backup users .gemrc file
#   #     add symlink to gem executable
#   #   
#   #   read in activate template
#   #   write out activate script to target/bin
#     
# end