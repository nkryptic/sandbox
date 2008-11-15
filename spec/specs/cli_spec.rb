require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/cli'

describe Workspace::CLI, "execute" do
  # before( :each ) do
  #   @stdout_io = StringIO.new
  #   Workspace::CLI.stdout = @stdout_io
  #   Workspace::CLI.execute( [] )
  #   @stdout_io.rewind
  #   @output = @stdout_io.read
  # end
  
  # it "should do something" do
  #   @output.should =~ /To update this executable/
  # end
  
  describe "with valid arguments" do
    it "should print the version for option '-v'" do
      stdout,stderr = capture(:stdout,:stderr) do
        begin
          Workspace::CLI.execute( ['-v'] )
        rescue SystemExit => e
          e.status.should == 0
        end
      end
      stdout.chomp.should == Workspace::Version::STRING
    end

    it "should print the version for option '--version'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { Workspace::CLI.execute( ['--version'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.chomp.should == Workspace::Version::STRING
    end

    it "should provide a help message for option '-h'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { Workspace::CLI.execute( ['-h'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end

    it "should provide a help message for option '--help'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { Workspace::CLI.execute( ['--help'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end
    
    it "should provide a help message for no options" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { Workspace::CLI.execute( [] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end

    it "should provide a help message on 'help'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { Workspace::CLI.execute( ['help'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end
    # 
    # it "should provide a help message for command on 'command -h'" do
    #   stdout = capture(:stdout) { Workspace::CLI.execute( ['command','-h'] ) }
    #   stdout.should =~ /To update this executable/
    # end
    # 
    # it "should provide a help message for command on 'help command'" do
    #   stdout = capture(:stdout) { Workspace::CLI.execute( ['help','command'] ) }
    #   stdout.should =~ /To update this executable/
    # end
  end
  
  describe "with invalid arguments" do
    it "should should display warning with help message on bad option" do
      # pending( "Needs to be written" )
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { Workspace::CLI.execute( ['-x'] ) }.should raise_error( SystemExit ) { |error| error.status.should == 1 }
      end
      stdout.should =~ /^Error: /
      stdout.should =~ /Usage: /
      stdout.should =~ /available commands:/
    end
  end
  
end