require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/command_manager'


describe Workspace::CommandManager, 'instance' do
  
  before( :each ) do
    @mgr = Workspace::CommandManager.new
    @cmd_names = %w{ known party pardon }
  end
  
  describe "when calling find_command_mathces" do
    
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
    
    it "should return command based on valid name argument" do
      pending( "Needs to be written" )
    end
    
  end
  
end