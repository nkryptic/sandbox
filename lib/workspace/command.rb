
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
    
    def description
      nil
    end
    
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
    
    def configure_parser_options( opt_parser, option_list )
      return if option_list.nil? or option_list.empty?
      
      # header = header.to_s.empty? ? '' : "#{header} "
      # opt_parser.separator "  #{header}Options:"
      
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
        
        o.separator "  Options:"
        configure_parser_options( o, parser_opts )
        
        o.separator "  Common Options:"
        configure_parser_options( o, Workspace::Command.common_parser_opts )
        
        # o.separator "  Arguments:"
        # o.separator "    #{arguments}"
        # o.separator ""
        
        o.separator "  Summary:"
        o.separator "    #{summary}"
        o.separator ""
        
        o.separator "  Description:"
        o.separator "    #{description}"
        o.separator ""
        
        # o.separator "  Defaults:"
        # o.separator "    #{default_str}"
        # o.separator ""
      end
    end
    
    def parser_opts
      []
    end
    
    
    
    ###### MONGREL COMMAND
    # # Called by the implemented command to set the options for that command.
    # # Every option has a short and long version, a description, a variable to
    # # set, and a default value.  No exceptions.
    # def options(opts)
    #   # process the given options array
    #   opts.each do |short, long, help, variable, default|
    #     self.instance_variable_set(variable, default)
    #     @opt.on(short, long, help) do |arg|
    #       self.instance_variable_set(variable, arg)
    #     end
    #   end
    # end
    # 
    # # Called by the subclass to setup the command and parse the argv arguments.
    # # The call is destructive on argv since it uses the OptionParser#parse! function.
    # def initialize(options={})
    #   argv = options[:argv] || []
    #   @opt = OptionParser.new
    #   @opt.banner = Mongrel::Command::BANNER
    #   @valid = true
    #   # this is retarded, but it has to be done this way because -h and -v exit
    #   @done_validating = false
    #   @original_args = argv.dup
    # 
    #   configure
    # 
    #   # I need to add my own -h definition to prevent the -h by default from exiting.
    #   @opt.on_tail("-h", "--help", "Show this message") do
    #     @done_validating = true
    #     puts @opt
    #   end
    # 
    #   # I need to add my own -v definition to prevent the -v from exiting by default as well.
    #   @opt.on_tail("--version", "Show version") do
    #     @done_validating = true
    #     if VERSION
    #       puts "Version #{Mongrel::Const::MONGREL_VERSION}"
    #     end
    #   end
    # 
    #   @opt.parse! argv
    # end
    # 
    # def configure
    #   options []
    # end
    # def configure
    #   options [
    #     ["-e", "--environment ENV", "Rails environment to run as", :@environment, ENV['RAILS_ENV'] || "development"],
    #     ["-d", "--daemonize", "Run daemonized in the background", :@daemon, false],
    #     ['-p', '--port PORT', "Which port to bind to", :@port, 3000],
    #     ['-a', '--address ADDR', "Address to bind to", :@address, "0.0.0.0"],
    #     ['-l', '--log FILE', "Where to write log messages", :@log_file, "log/mongrel.log"],
    #     ['-P', '--pid FILE', "Where to write the PID", :@pid_file, "log/mongrel.pid"],
    #     ['-n', '--num-processors INT', "Number of processors active before clients denied", :@num_processors, 1024],
    #     ['-o', '--timeout TIME', "Time to wait (in seconds) before killing a stalled thread", :@timeout, 60],
    #     ['-t', '--throttle TIME', "Time to pause (in hundredths of a second) between accepting clients", :@throttle, 0],
    #     ['-m', '--mime PATH', "A YAML file that lists additional MIME types", :@mime_map, nil],
    #     ['-c', '--chdir PATH', "Change to dir before starting (will be expanded)", :@cwd, Dir.pwd],
    #     ['-r', '--root PATH', "Set the document root (default 'public')", :@docroot, "public"],
    #     ['-B', '--debug', "Enable debugging mode", :@debug, false],
    #     ['-C', '--config PATH', "Use a config file", :@config_file, nil],
    #     ['-S', '--script PATH', "Load the given file as an extra config script", :@config_script, nil],
    #     ['-G', '--generate PATH', "Generate a config file for use with -C", :@generate, nil],
    #     ['', '--user USER', "User to run as", :@user, nil],
    #     ['', '--group GROUP', "Group to run as", :@group, nil],
    #     ['', '--prefix PATH', "URL prefix for Rails app", :@prefix, nil]
    #   ]
    # end
    
    
    
    ###### RUBYGEMS HELP COMMAND
    # def arguments # :nodoc:
    #   args = <<-EOF
    #     commands      List all 'gem' commands
    #     examples      Show examples of 'gem' usage
    #     <command>     Show specific help for <command>
    #   EOF
    #   return args.gsub(/^\s+/, '')
    # end
    # 
    # def usage # :nodoc:
    #   "#{program_name} ARGUMENT"
    # end
    # 
    # def execute
    #   command_manager = Gem::CommandManager.instance
    #   arg = options[:args][0]
    # 
    #   if begins? "commands", arg then
    #     out = []
    #     out << "GEM commands are:"
    #     out << nil
    # 
    #     margin_width = 4
    # 
    #     desc_width = command_manager.command_names.map { |n| n.size }.max + 4
    # 
    #     summary_width = 80 - margin_width - desc_width
    #     wrap_indent = ' ' * (margin_width + desc_width)
    #     format = "#{' ' * margin_width}%-#{desc_width}s%s"
    # 
    #     command_manager.command_names.each do |cmd_name|
    #       summary = command_manager[cmd_name].summary
    #       summary = wrap(summary, summary_width).split "\n"
    #       out << sprintf(format, cmd_name, summary.shift)
    #       until summary.empty? do
    #         out << "#{wrap_indent}#{summary.shift}"
    #       end
    #     end
    # 
    #     out << nil
    #     out << "For help on a particular command, use 'gem help COMMAND'."
    #     out << nil
    #     out << "Commands may be abbreviated, so long as they are unambiguous."
    #     out << "e.g. 'gem i rake' is short for 'gem install rake'."
    # 
    #     say out.join("\n")
    # 
    #   elsif begins? "options", arg then
    #     say Gem::Command::HELP
    # 
    #   elsif begins? "examples", arg then
    #     say EXAMPLES
    # 
    #   elsif begins? "platforms", arg then
    #     say PLATFORMS
    # 
    #   elsif options[:help] then
    #     command = command_manager[options[:help]]
    #     if command
    #       # help with provided command
    #       command.invoke("--help")
    #     else
    #       alert_error "Unknown command #{options[:help]}.  Try 'gem help commands'"
    #     end
    # 
    #   elsif arg then
    #     possibilities = command_manager.find_command_possibilities(arg.downcase)
    #     if possibilities.size == 1
    #       command = command_manager[possibilities.first]
    #       command.invoke("--help")
    #     elsif possibilities.size > 1
    #       alert_warning "Ambiguous command #{arg} (#{possibilities.join(', ')})"
    #     else
    #       alert_warning "Unknown command #{arg}. Try gem help commands"
    #     end
    # 
    #   else
    #     say Gem::Command::HELP
    #   end
    # end
    
    ###### RUBYGEMS COMMAND
    # # Override to provide details of the arguments a command takes.
    # # It should return a left-justified string, one argument per line.
    # def arguments
    #   ""
    # end
    # 
    # # Override to display the default values of the command
    # # options. (similar to +arguments+, but displays the default
    # # values).
    # def defaults_str
    #   ""
    # end
    # 
    # # Override to display a longer description of what this command does.
    # def description
    #   nil
    # end
    # 
    # # Override to display the usage for an individual gem command.
    # def usage
    #   program_name
    # end
    # 
    # # Display the help message for the command.
    # def show_help
    #   parser.program_name = usage
    #   say parser
    # end
    # # Add a command-line option and handler to the command.
    # #
    # # See OptionParser#make_switch for an explanation of +opts+.
    # #
    # # +handler+ will be called with two values, the value of the argument and
    # # the options hash.
    # def add_option(*opts, &handler) # :yields: value, options
    #   group_name = Symbol === opts.first ? opts.shift : :options
    # 
    #   @option_groups[group_name] << [opts, handler]
    # end
    # 
    # # Merge a set of command options with the set of default options
    # # (without modifying the default option hash).
    # def merge_options(new_options)
    #   @options = @defaults.clone
    #   new_options.each do |k,v| @options[k] = v end
    # end
    # 
    # # Handle the given list of arguments by parsing them and recording the results.
    # def handle_options(args)
    #   args = add_extra_args(args)
    #   @options = @defaults.clone
    #   parser.parse!(args)
    #   @options[:args] = args
    # end
    # 
    # def create_option_parser
    #   @parser = OptionParser.new
    # 
    #   @parser.separator("")
    #   regular_options = @option_groups.delete :options
    # 
    #   configure_options "", regular_options
    # 
    #   @option_groups.sort_by { |n,_| n.to_s }.each do |group_name, option_list|
    #     configure_options group_name, option_list
    #   end
    # 
    #   configure_options "Common", Command.common_parser_opts
    # 
    #   @parser.separator("")
    #   unless arguments.empty?
    #     @parser.separator("  Arguments:")
    #     arguments.split(/\n/).each do |arg_desc|
    #       @parser.separator("    #{arg_desc}")
    #     end
    #     @parser.separator("")
    #   end
    # 
    #   @parser.separator("  Summary:")
    #   wrap(@summary, 80 - 4).split("\n").each do |line|
    #     @parser.separator("    #{line.strip}")
    #   end
    # 
    #   if description then
    #     formatted = description.split("\n\n").map do |chunk|
    #       wrap(chunk, 80 - 4)
    #     end.join("\n")
    # 
    #     @parser.separator ""
    #     @parser.separator "  Description:"
    #     formatted.split("\n").each do |line|
    #       @parser.separator "    #{line.rstrip}"
    #     end
    #   end
    # 
    #   unless defaults_str.empty?
    #     @parser.separator("")
    #     @parser.separator("  Defaults:")
    #     defaults_str.split(/\n/).each do |line|
    #       @parser.separator("    #{line}")
    #     end
    #   end
    # end
    # 
    # def configure_options(header, option_list)
    #   return if option_list.nil? or option_list.empty?
    # 
    #   header = header.to_s.empty? ? '' : "#{header} "
    #   @parser.separator "  #{header}Options:"
    # 
    #   option_list.each do |args, handler|
    #     dashes = args.select { |arg| arg =~ /^-/ }
    #     @parser.on(*args) do |value|
    #       handler.call(value, @options)
    #     end
    #   end
    # 
    #   @parser.separator ''
    # end
    # 
    # # Wraps +text+ to +width+
    # def wrap(text, width)
    #   text.gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
    # end
    
    ## END PUBLIC INSTANCE METHODS
    
    
    ## PRIVATE INSTANCE METHODS
    private
      
    ## END PRIVATE INSTANCE METHODS
    
  end
  
  
  # This is where individual Commands will be placed in the namespace
  module Commands; end
  
end