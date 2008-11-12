require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/cli'

describe Workspace::CLI, "execute" do
  before( :each ) do
    @stdout_io = StringIO.new
    Workspace::CLI.stdout = @stdout_io
    Workspace::CLI.execute( [] )
    @stdout_io.rewind
    @output = @stdout_io.read
  end
  
  it "should do something" do
    @output.should =~ /To update this executable/
  end
end