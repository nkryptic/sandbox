require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/command'


describe Workspace::Command, 'instance' do
  # after( :each ) do
  #   Object.instance_eval{ remove_const :X } if Object.instance_eval{ const_defined? :NewCommand }
  # end
  # 
  # it "should call register when subclassed" do
  #   Workspace::Command.expects(:register)
  #   class NewCommand < Workspace::Command
  #   end
  # end
  
  it "should require argument on creation" do
    lambda { Workspace::Command.new }.should raise_error( ArgumentError )
  end
  
  it "should respond to parse_options!" do
    @cmd = Workspace::Command.new( 'test' )
    @cmd.should respond_to( :parse_options! )
  end
  
  
  # before( :each ) do
  #   @command = Workspace::Command.new
  # end
  # 
  # describe "with valid arguments" do
  #   it "should print the version for option '--version'" do
  #     stdout,stderr = capture(:stdout,:stderr) do
  #       # lambda { Workspace::CLI.execute( ['--version'] ) }.
  #       lambda { @cli.parse_options!( ['--version'] ) }.
  #           should raise_error( SystemExit ) { |error| error.status.should == 0 }
  #     end
  #     stdout.chomp.should == "workspace v#{Workspace::Version::STRING}"
  #   end
  #   
  #   it "should ignore additional arguments after '-v' [test]" do
  #     @cli.expects(:puts).with( "workspace v#{Workspace::Version::STRING}" )
  #     lambda { @cli.parse_options!( ['-v', '-h'] ) }.
  #         should raise_error( SystemExit ) { |error| error.status.should == 0 }
  #   end
  # end
end

# describe Workspace::Command, "somemethod" do
# end