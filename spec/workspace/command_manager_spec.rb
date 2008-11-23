
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/command_manager'

describe Workspace::CommandManager do
  
  describe "when initializing" do
    
    it "should call setup, but not load commands when passed autoload=false" do
      Workspace::CommandManager.stubs( :commands ).returns( [ :a, :b, :c ] )
      Workspace::CommandManager.any_instance.expects( :load_command ).never
      
      @mgr = Workspace::CommandManager.new
      @mgr.command_names.should have(3).items
    end
    
    it "should call setup and load commands when passed autoload=true" do
      Workspace::CommandManager.stubs( :commands ).returns( [ :a, :b, :c ] )
      Workspace::CommandManager.any_instance.expects( :load_command ).times( 3 )
      
      @mgr = Workspace::CommandManager.new( true )
      @mgr.command_names.should have(3).items
    end
    
  end
  
end

describe Workspace::CommandManager, 'instance' do
  
  before( :each ) do
    @mgr = Workspace::CommandManager.new
    @cmd_names = %w{ known party pardon }
  end
  
  describe "when calling load_command [PRIVATE]" do
    
    it "should load matching command class when not loaded" do
      dummy = mock( 'DummyCommand' )
      dummy_instance = mock( 'DummyCommand' )
      dummy.expects( :new ).returns( dummy_instance )
      Workspace::Commands.expects( :const_get ).with( 'DummyCommand' ).
          times(2).raises( NameError ).then.returns( dummy )
      @mgr.expects( :require ).with( 'workspace/commands/dummy_command' )
      
      Workspace::CommandManager.publicize_methods do
        @mgr.load_command( :dummy ).should == dummy_instance
      end
    end
    
    it "should raise error when loading command class fails" do
      # dummy = mock( 'DummyCommand' )
      # dummy_instance = mock( 'DummyCommand' )
      # dummy.expects( :new ).returns( dummy_instance )
      Workspace::Commands.expects( :const_get ).with( 'DummyCommand' ).
          times(2).raises( NameError )
      @mgr.expects( :require ).with( 'workspace/commands/dummy_command' )
      
      Workspace::CommandManager.publicize_methods do
        lambda { @mgr.load_command( :dummy ) }.should raise_error( NameError )
      end
    end
    
  end
  
  describe "when calling find_command_matches" do
    
    it "should find no matches on bad name argument" do
      @mgr.expects( :command_names ).returns( @cmd_names )
      
      @mgr.find_command_matches( 'unknown' ).should == []
    end
    
    it "should find 1 match on exact name argument" do
      @mgr.expects( :command_names ).returns( @cmd_names )
      
      @mgr.find_command_matches( 'known' ).should == [ 'known' ]
    end
    
    it "should find many matches on partial name argument" do
      @mgr.expects( :command_names ).returns( @cmd_names )
      
      @mgr.find_command_matches( 'par' ).should == [ 'party', 'pardon' ]
    end
    
  end
  
  describe "when calling []" do
    
    it "should return command with valid name argument" do
      known = mock( 'KnownCommand' )
      # @mgr.instance_eval "@commands['known']=(#{ known }"
      @mgr.instance_eval { @commands[ :known ] = known }
      
      @mgr[ 'known' ].should_not be_nil
      @mgr[ 'known' ].should == known
    end
    
    it "should return nil with invalid name argument" do
      @mgr[ 'unknown' ].should be_nil
    end
    
  end
  
  describe "when calling command_names" do
    
    it "should return sorted list of valid commands" do
      cmds = { :c => 1, :a => 2, :b => 3 }
      # @mgr.instance_eval "@commands['known']=(#{ known }"
      @mgr.instance_eval { @commands = cmds }
      
      @mgr.command_names.should == [ 'a', 'b', 'c' ]
    end
    
  end
  
end