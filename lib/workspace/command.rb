
require 'optparse'


module Workspace
  class Command
    
    ## CLASS METHODS
    class << self
      def common_parser_opts
        [
          [ ["-h", '--help', 'Show help on this command'], Proc.new { |val,opts| opts[ :help ] = true } ],
          [ ["-v", '--verbose', 'Show more output'], Proc.new { |val,opts| opts[ :verbosity ] ||= 0; opts[ :verbosity ] += 1 } ],
          [ ["-q", '--quiet', 'Show less output'], Proc.new { |val,opts| opts[ :verbosity ] ||= 0; opts[ :verbosity ] -= 1 } ],
        ]
      end
    end
    ## END CLASS METHODS
    
    # The name of the command.
    attr_reader :name
    
    # The options for the command.
    attr_reader :options
    
    # The default options for the command.
    attr_accessor :defaults
    
    # # The name of the command for command-line invocation.
    attr_accessor :cli_string
     
    # A short description of the command.
    attr_accessor :summary
    
    ## PUBLIC INSTANCE METHODS
    def initialize( name, summary=nil, defaults={} )
      @name = name
      @summary = summary
      @cli_string = "workspace #{name}"
      @defaults = defaults
      @options = defaults.dup
      # @option_groups = Hash.new { |h,k| h[k] = [] }
      @parser = nil
    end
    
    def run( args )
      process_options!( args )
      if options[ :help ]
        show_help
      else
        execute!
      end
    end
    
    # Override to provide command handling.
    def execute!
      raise NotImplementedError, "'execute!' must be implemented by #{self.class.name}"
    end
    
    def process_options!( args )
      begin
        parser.parse!( args )
      rescue OptionParser::ParseError => e
        puts "Error: #{ e }"
        puts "see '#{cli_string} --help'"
        exit 1
      end
      options[ :args ] = args
    end
    
    # Override to display a longer description of what this command does.
    def description
      nil
    end
    
    # Override to display the usage for an individual command.
    def usage
      cli_string
    end
    
    def show_help
      parser.program_name = usage
      puts parser
    end
    
    # # Merge a set of command options with the set of default options
    # # (without modifying the default option hash).
    # def merge_options(new_options)
    #   @options = @defaults.clone
    #   new_options.each do |k,v| @options[k] = v end
    # end
    
    def configure_parser_options( opt_parser, header, option_list )
      return if option_list.nil? or option_list.empty?
      
      header = header.to_s.empty? ? '' : "#{header} "
      opt_parser.separator "  #{header}Options:"
      
      # process the given options array
      option_list.each do |args, handler|
        opt_parser.on( *args ) do |value|
          handler.call( value, @options )
        end
      end
      
      opt_parser.separator ''
    end
    
    def parser
      @parser ||= OptionParser.new do |o|
        # o.banner = "Usage: #{usage}"
        o.separator ""
        
        # o.separator "  Options:"
        configure_parser_options( o, '', parser_opts )
        
        # o.separator "   Options:"
        configure_parser_options( o, 'Common', Workspace::Command.common_parser_opts )
        
        # if arguments
        #   o.separator "  Arguments:"
        #   o.separator "    #{arguments}"
        #   o.separator ""
        # end
        
        if summary
          o.separator "  Summary:"
          o.separator "    #{summary}"
          # formatter( summary ).each do |line|
          #   o.separator( line )
          # end
          o.separator ""
        end
        
        if description
          o.separator "  Description:"
          o.separator "    #{description}"
          o.separator ""
        end
        
        # if default_str
        #   o.separator "  Defaults:"
        #   o.separator "    #{default_str}"
        #   o.separator ""
        # end
      end
    end
    
    def parser_opts
      []
    end
    
    def formatter( text, padding=4, width=80 )
      # return unless block_given?
      wrapped = wrap( text, max - padding )
      wrapped.split( "\n" ).collect do |line|
        "%#{max}s" % line.strip
        # yield "%#{max}s" % line.strip
      end
    end
    
    # Wraps +text+ to +width+
    def wrap( text, width )
      text.gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
    end
    
    
    ###### RUBYGEMS COMMAND
    # Override to provide details of the arguments a command takes.
    # It should return a left-justified string, one argument per line.
    # def arguments
    #   ""
    # end
    # 
    # Override to display the default values of the command
    # options. (similar to +arguments+, but displays the default
    # values).
    # def defaults_str
    #   ""
    # end
    
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      
    ## END PRIVATE INSTANCE METHODS
    
  end
  
  
  # This is where individual Commands will be placed in the namespace
  module Commands; end
  
end