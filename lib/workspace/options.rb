module Workspace
  class Options
    attr_reader :commands
    ## CLASS METHODS
    class << self
    end
    
    ## INSTANCE METHODS
    def initialize
      @global_options = []
      @commands = []
      @command_options = []
      yield self if block_given?
    end
    
    def command( cmd )
      @commands << cmd
    end
  end
end