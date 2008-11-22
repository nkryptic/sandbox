require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/options'

describe Workspace::Options do
  
  # describe "when unconfigured" do
  #   before( :each ) do
  #     @opts = Workspace::Options.new
  #   end
  # 
  #   # it "should allow 0 args" do
  #   #   @opts.parse!.should == []
  #   # end
  # end
  # 
  # describe "when configuring instance" do
  #   before( :each ) do
  #     @opts = Workspace::Options.new
  #   end
  #   # it "should allow command definition" do
  #   #   @opts.should respond_to :add_command
  #   # end
  # end
  # 
  # describe "when configuring instance in block" do
  #   it "should yield itself when created" do
  #     subject = mock('block_tester') do
  #       expects(:block_executed).yields(Workspace::Options)
  #     end
  #     Workspace::Options.new do |opt|
  #       subject.block_executed {|klass| opt.class.should == klass}
  #     end
  #   end
  #   
  #   it "should allow addition of commands" do
  #     # fake_command = stub_everything()
  #     Workspace::Options.new do |opt|
  #       lambda { opt.command "fake_command" }.should change( opt.commands, :size ).by(1)
  #     end
  #   end
  # end
  
end
