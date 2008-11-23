
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
  
  it "should require array of arguements for process_options!" do
    lambda { @cmd.process_options! }.
        should raise_error( ArgumentError ) { |error| error.message.should =~ /0 for 1/ }
    lambda { @cmd.process_options!( [] ) }.should_not raise_error( ArgumentError )
  end
  
  it "should accept global options for process_options!" do
    lambda { @cmd.process_options!( [], { :something => true } ) }.should_not raise_error( ArgumentError )
  end
  
  it "should raise NotImplementedError on execute!" do
    lambda { @cmd.execute! }.
        should raise_error( NotImplementedError ) { |error| error.message.should =~ /is not implemented/ }
  end
  
  it "should have a description"
  it "should have a summary"
  it "should have a usage"
  it "should have a description"
  it "should have a parser"
  
  describe "calling process_options!" do
    
    describe "with valid arguments" do
      
      it "should merge global options"
      
      it "should call show_help for option '-h'" do
        pending( "code not written yet" )
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
