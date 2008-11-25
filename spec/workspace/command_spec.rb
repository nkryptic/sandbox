
require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/command'


describe Workspace::Command do
  
  it "should require a name when calling 'new'" do
    lambda { Workspace::Command.new }.
        should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
  end
  
end

describe Workspace::Command, 'instance' do
  
  before( :each ) do
    @cmd = Workspace::Command.new( 'dummy' )
  end
  
  it "should raise NotImplementedError on execute!" do
    lambda { @cmd.execute! }.
        should raise_error( NotImplementedError ) { |error| error.message.should =~ /is not implemented/ }
  end
  
  it "should have a name"
  it "should have a description"
  it "should have a summary"
  it "should have a usage"
  it "should have a options"
  it "should have a defaults"
  it "should have a parser"
  
  describe "calling run" do
    
    it "should require array of arguements" do
      lambda { @cmd.run }.
          should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
      lambda { @cmd.run( [] ) }.should_not raise_error()
    end
    
    it "should accept global options hash" do
      lambda { @cmd.run( [], { :something => true } ) }.should_not raise_error()
    end
    
    it "should merge global options"
    
  end
  
  describe "calling process_options!" do
    
    it "should require array of arguements" do
      lambda { @cmd.process_options! }.
          should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
      lambda { @cmd.process_options!( [] ) }.should_not raise_error( ArgumentError )
    end
    
    describe "with valid arguments" do
      
      it "should call show_help for option '-h'" do
        @cmd.expects( :show_help )
        # io = capture() do
          lambda { @cmd.process_options!( ['-h'] ) }.
              should raise_error( SystemExit ) { |error| error.status.should == 0 }
        # end
        # io.stdout.chomp.should == "Usage"
      end
      
      # it "should description" do
      #   pending( "Needs to be written" )
      # end
      
    end
    
  end
  
end
