
require 'optparse'


module Sandbox
  class Command
    
    ## CLASS METHODS
    class << self
      def common_parser_opts
        [
          [ ["-h", '--help', 'Show help on this command'], Proc.new { |val,opts| opts[ :help ] = true } ],
          [ ["-v", '--verbose', 'Show more output'], Proc.new { |val,opts| Sandbox.increase_verbosity } ],
          [ ["-q", '--quiet', 'Show less output'], Proc.new { |val,opts| Sandbox.decrease_verbosity } ],
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
      @cli_string = "sandbox #{name}"
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
      parser.parse!( args )
    rescue OptionParser::ParseError => ex
      raise_parse_error( ex.reason, ex.args )
    else
      options[ :args ] = args
    end
    
    def raise_parse_error( reason, args=[] )
      help_str = "#{cli_string} --help"
      raise Sandbox::ParseError.new( reason, args, help_str )
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
        configure_parser_options( o, 'Common', Sandbox::Command.common_parser_opts )
        
        if arguments.size > 0
          o.separator "  Arguments:"
          nested_formatter( arguments ).each do |line|
            o.separator( line )
          end
          # o.separator "    #{arguments}"
          o.separator ""
        end
        
        if summary
          o.separator "  Summary:"
          # o.separator "    #{summary}"
          formatter( summary ).each do |line|
            o.separator( line )
          end
          o.separator ""
        end
        
        if description
          o.separator "  Description:"
          formatter( description ).each do |line|
            o.separator( line )
          end
          # o.separator "    #{description}"
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
      wrapped = wrap( text, width - padding )
      wrapped.split( "\n" ).collect do |line|
        "#{' ' * padding}%s" % line.strip
        # yield "%#{max}s" % line.strip
      end
    end
    
    def nested_formatter( lines, padding=4, width=80 )
      out = []
      return out if lines.empty?
      left_margin = 4
      center_width = lines.map { |n| n.first.size }.max + 4
      right_width = 80 - left_margin - center_width
      wrap_indent = ' ' * (left_margin + center_width)
      format = "#{' ' * left_margin}%-#{center_width}s%s"
      
      lines.each do |n|
        right = wrap( n[1], right_width ).split( "\n" )
        out << sprintf( format, n[0], right.shift )
        until right.empty? do
          out << "#{wrap_indent}#{right.shift}"
        end
      end
      out
    end
    
    # Wraps +text+ to +width+
    def wrap( text, width )
      text.gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
    end
    
    def matches?( full, part )
      return false if part.nil? or part.empty?
      full.slice( 0..part.length ) == part
    end
    
    
    ###### RUBYGEMS COMMAND
    # Override to provide details of the arguments a command takes.
    # It should return a left-justified string, one argument per line.
    def arguments
      []
    end
    
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