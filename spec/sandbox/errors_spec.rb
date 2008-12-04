
require File.dirname( __FILE__ ) + '/../spec_helper.rb'

describe 'new', Sandbox::Error do
  it "should wrap it's message with 'Sandbox error'" do
    Sandbox::Error.new( 'msg' ).message.should == 'Sandbox error: msg'
  end
end

describe 'new', Sandbox::LoadedSandboxError do
  it "should have informative default msg" do
    Sandbox::LoadedSandboxError.new.message.should =~ /loaded sandbox/
  end
end

describe 'new', Sandbox::ParseError do
  it "should accept reason with array" do
    Sandbox::ParseError.new( 'testing', [ 1, 2, 3, 4 ] ).
        message.should =~ /testing => 1 2 3 4/
  end
  
  it "should accept reason with string" do
    Sandbox::ParseError.new( 'testing', "1, 2, 3, 4" ).
        message.should =~ /testing => 1, 2, 3, 4/
  end
  
  it "should fall back to reason alone" do
    Sandbox::ParseError.new( 'testing', [] ).
        message.should =~ /testing$/
    Sandbox::ParseError.new( 'testing', '' ).
        message.should =~ /testing$/
  end
end

