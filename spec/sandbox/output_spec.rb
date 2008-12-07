
require File.dirname( __FILE__ ) + '/../spec_helper.rb'

describe 'including', Sandbox::Output do
  class Tester
    include Sandbox::Output
  end
  
  before( :each ) do
    Sandbox.instance_eval { instance_variables.each { |v| remove_instance_variable v } }
    @tester = Tester.new
  end
  
  it "should have tell method" do
    @tester.should respond_to( :tell )
  end
  
  it "should have tell_when_verbose method" do
    @tester.should respond_to( :tell_when_verbose )
  end
  
  it "should have tell_when_really_verbose method" do
    @tester.should respond_to( :tell_when_really_verbose )
  end
  
  it "should have tell_unless_quiet method" do
    @tester.should respond_to( :tell_unless_quiet )
  end
  
  it "should have tell_unless_really_quiet method" do
    @tester.should respond_to( :tell_unless_really_quiet )
  end
  
  describe "calling tell" do
    it "should require message" do
      lambda { @tester.tell }.should raise_error( ArgumentError )
    end
    
    it "should call puts when normal" do
      @tester.expects( :puts )
      @tester.tell( "message" )
    end
    
    it "should not call puts when below normal verbosity" do
      Sandbox.decrease_verbosity
      @tester.expects( :puts ).never
      @tester.tell( "message" )
    end
    
    it "should call puts when above normal verbosity" do
      Sandbox.increase_verbosity
      @tester.expects( :puts )
      @tester.tell( "message" )
    end
  end
  
  describe "calling tell_when_verbose" do
    it "should require message" do
      lambda { @tester.tell_when_verbose }.should raise_error( ArgumentError )
    end
    
    it "should not call puts when normal verbosity" do
      @tester.expects( :puts ).never
      @tester.tell_when_verbose( "message" )
    end
    
    it "should call puts when above normal verbosity" do
      Sandbox.increase_verbosity
      @tester.expects( :puts )
      @tester.tell_when_verbose( "message" )
    end
  end
  
  describe "calling tell_when_really_verbose" do
    it "should require message" do
      lambda { @tester.tell_when_really_verbose }.should raise_error( ArgumentError )
    end
    
    it "should not call puts when normal verbosity" do
      @tester.expects( :puts ).never
      @tester.tell_when_really_verbose( "message" )
    end
    
    it "should call puts when above normal verbosity" do
      Sandbox.increase_verbosity
      @tester.expects( :puts ).never
      @tester.tell_when_really_verbose( "message" )
    end
    
    it "should call puts when really above normal verbosity" do
      Sandbox.increase_verbosity
      Sandbox.increase_verbosity
      @tester.expects( :puts )
      @tester.tell_when_really_verbose( "message" )
    end
  end
  
  describe "calling tell_unless_quiet" do
    it "should require message" do
      lambda { @tester.tell_unless_quiet }.should raise_error( ArgumentError )
    end
    
    it "should call puts when normal" do
      @tester.expects( :puts )
      @tester.tell_unless_quiet( "message" )
    end
    
    it "should not call puts when below normal verbosity" do
      Sandbox.decrease_verbosity
      @tester.expects( :puts ).never
      @tester.tell_unless_quiet( "message" )
    end
    
    it "should call puts when above normal verbosity" do
      Sandbox.increase_verbosity
      @tester.expects( :puts )
      @tester.tell_unless_quiet( "message" )
    end
  end
  
  describe "calling tell_unless_really_quiet" do
    it "should require message" do
      lambda { @tester.tell_unless_really_quiet }.should raise_error( ArgumentError )
    end
    
    it "should call puts when normal" do
      @tester.expects( :puts )
      @tester.tell_unless_really_quiet( "message" )
    end
    
    it "should call puts when below normal verbosity" do
      Sandbox.decrease_verbosity
      @tester.expects( :puts )
      @tester.tell_unless_really_quiet( "message" )
    end
    
    it "should not call puts when really below normal verbosity" do
      Sandbox.decrease_verbosity
      Sandbox.decrease_verbosity
      @tester.expects( :puts ).never
      @tester.tell_unless_really_quiet( "message" )
    end
  end
  
end

