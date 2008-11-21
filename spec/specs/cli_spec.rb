require File.dirname( __FILE__ ) + '/../spec_helper'
require 'workspace/cli'

# describe Workspace::CLI, "execute" do
describe Workspace::CLI, "parse_options!" do
  # before( :each ) do
  #   @stdout_io = StringIO.new
  #   Workspace::CLI.stdout = @stdout_io
  #   Workspace::CLI.execute( [] )
  #   @stdout_io.rewind
  #   @output = @stdout_io.read
  # end
  before( :each ) do
    # @stdout_io, @stderr_io = StringIO.new, StringIO.new
    # Workspace::CLI.set_io( @stdout_io, @stderr_io )
    @cli = Workspace::CLI.new
    # @output = @stdout_io.read if @stdout_io.rewind
    # @error_output = @stderr_io.read if @stderr_io.rewind
  end
  
  # it "should do something" do
  #   @output.should =~ /To update this executable/
  # end
  
  describe "with valid arguments" do
    it "should print the version for option '-v'" do
      stdout,stderr = capture(:stdout,:stderr) do
        begin
          # Workspace::CLI.execute( ['-v'] )
          @cli.parse_options!( ['-v'] )
        rescue SystemExit => e
          e.status.should == 0
        end
      end
      stdout.chomp.should == "workspace v#{Workspace::Version::STRING}"
    end

    it "should print the version for option '--version'" do
      stdout,stderr = capture(:stdout,:stderr) do
        # lambda { Workspace::CLI.execute( ['--version'] ) }.
        lambda { @cli.parse_options!( ['--version'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.chomp.should == "workspace v#{Workspace::Version::STRING}"
    end

    it "should provide a help message for option '-h'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['-h'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end

    it "should provide a help message for option '--help'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['--help'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end
    
    it "should provide a help message for no options" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( [] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end
    
    it "should ignore additional arguments after '-h'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['-h', '-v'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['-h', 'otherarg'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /available commands:/
    end
    
    it "should ignore additional arguments after '-v'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['-v', '-h'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.chomp.should == "workspace v#{Workspace::Version::STRING}"
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['-v', 'otherarg'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.chomp.should == "workspace v#{Workspace::Version::STRING}"
    end
    
    it "should ignore additional arguments after '-v' [test]" do
      @cli.expects(:puts).with( "workspace v#{Workspace::Version::STRING}" )
      lambda { @cli.parse_options!( ['-v', '-h'] ) }.
          should raise_error( SystemExit ) { |error| error.status.should == 0 }
    end

    # it "should provide a help message on 'help'" do
    #   stdout,stderr = capture(:stdout,:stderr) do
    #     lambda { @cli.parse_options!( ['help'] ) }.
    #         should raise_error( SystemExit ) { |error| error.status.should == 0 }
    #   end
    #   stdout.should =~ /^Usage: /
    #   stdout.should =~ /available commands:/
    # end
    # 
    it "should provide a help message for command on 'command -h'" do
      stdout,stderr = capture(:stdout,:stderr) do
        lambda { @cli.parse_options!( ['command','-h'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 0 }
      end
      stdout.should =~ /^Usage: /
      stdout.should =~ /command command performs/
    end
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
        lambda { @cli.parse_options!( ['-x'] ) }.
            should raise_error( SystemExit ) { |error| error.status.should == 1 }
      end
      stdout.should =~ /^Error: /
      stdout.should =~ /Usage: /
      stdout.should =~ /available commands:/
    end
  end
  
end