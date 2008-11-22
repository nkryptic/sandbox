require 'optparse'
require 'workspace'

module Workspace
  # class CommandManager
  #   # include Singleton
  #   class << self
  #     attr_reader :commands
  #     
  #     # def initialize
  #     #   @commands = {}
  #     # end
  #     
  #     def register( name, klass )
  #       @commands ||= {}
  #       @command[ name ] = klass
  #     end
  #     
  #     # def actions
  #     #   return @action_names if @action_names
  #     #   @action_names = @commands.keys
  #     #   @action_names.sort
  #     # end
  #   end
  # end
  
  # class Command
  #   def self.inherited( klass )
  #     parts = klass.to_s.split( '::' )
  #     name = parts.last.downcase
  #     CommandManager.instance.register( name, klass )
  #   end
  # end
  
  class CLI
    class << self
      # attr_writer :step_mother, :executor, :features
      
      def execute( args = ARGV )
        parse( args ).execute!
        # @execute_called = true
        # parse( ARGV ).execute!( @step_mother, @executor, @features )
      end
    
      # def execute_called?
      #   @execute_called
      # end
    
      def parse( args )
        cli = new
        cli.parse_options!(args)
        cli
      end
    end
    
    attr_reader :command, :options
    # attr_reader :debug
    
    # def initialize( out_stream = STDOUT, error_stream = STDERR )
    def initialize
      # @out_stream = out_stream
      # @error_stream = error_stream
      # @paths = []
      # @options = {
      #   :require => nil,
      #   :lang    => 'en',
      #   :dry_run => false,
      #   :source  => true,
      #   :snippets => true,
      #   :formats => {},
      #   :excludes => [],
      #   :scenario_names => nil
      # }
      # @active_format = DEFAULT_FORMAT
      @options = {
        :debug => false
      }
      # @command_manager = Workspace::CommandManager # .instance
    end
    
    # def parser #:nodoc:
    #   @parser ||= OptionParser.new do |opts|
    #     
    #     opts.banner = banner
    #     
    #     opts.on_tail( "-h", "--help", "Display this help message." ) do
    #       puts opts
    #       exit
    #     end
    #     
    #     opts.on_tail( "-v", "--version", "Display the version." ) do
    #       puts "workspace v#{ Workspace::Version::STRING }"
    #       exit
    #     end
    #     
    #     opts.on( "-d", "--debug", "Display all output" ) do
    #       options[:debug] = true
    #     end
    #     
    #   end
    # end
    
    # def parse_options!( args )
    #   # split application options, command, and command options
    #   args << '-h' if args.empty?
    #   global_args = []
    #   command_args = []
    #   command = nil
    #   while arg = args.shift do
    #     if arg =~ /^-/
    #       global_args << arg
    #       global_args << args.shift if requires_arg?( arg )
    #     else
    #       command = arg.downcase
    #       command_args = args
    #       break
    #     end
    #   end
    #   
    #   begin
    #     parser.parse!( global_options )
    #   rescue OptionParser::ParseError => e
    #     puts "Error: unknown option #{ e }"
    #     puts parser
    #     exit 1
    #   end
    # end
    # 
    # def requires_arg?( arg )
    #   if arg =~ /^(--.*)=(.*)/
    #     return false unless $2.blank?
    #     arg = $1
    #   elsif arg =~ /^(-[^-])(.*)/
    #     return false unless $2.blank?
    #     arg = $1
    #   end
    #   
    #   len = arg.length
    #   switches = global_switches.keys.select { |sw| arg == sw[0,len] }
    #   if switches.size > 1
    #     raise "Ambiguous option #{arg} matches [#{switches.join(', ')}]"
    #   end
    #   
    #   if global_switches[ switches[0] ] == :need_arg
    #     return true
    #   end
    #   
    #   false
    # end
    # 
    # def global_switches
    #   @global_switches ||= parser.top.list.inject({}) do |hsh,switch|
    #     case switch
    #       when OptionParser::Switch::RequiredArgument, 
    #            OptionParser::Switch::PlacedArgument
    #         argtype = :need_arg
    #       when OptionParser::Switch::OptionalArgument # -rblue or --red=blue
    #         argtype = :opt_arg
    #       when OptionParser::Switch::NoArgument
    #         argtype = :no_arg
    #     else
    #       return hsh
    #     end
    #     short, long = switch.short.first, switch.long.first
    #     hsh[ short ] = argtype if short
    #     hsh[ long ] = argtype if long
    #     hsh
    #   end
    # end
    
    # #################
    # # older parse
    # def parse_options!( args )
    #   # split application options, command, and command options
    #   case cmd
    #   when '-v', '--version'
    #     puts Workspace::Version::STRING
    #     exit( 0 )
    #   when '-h', '--help', nil
    #     puts banner
    #     exit( 0 )
    #   when /^\-/
    #     puts "Error: unknown option #{args.first}"
    #     puts banner
    #     exit( 1 )
    #   when 'help'
    #     puts banner
    #     exit( 0 )
    #   end
    # end
    # #################
    # # older parse
    def parse_options!( args )   
      command_name = nil
      command_options = []
      # arg = args.shift
      
      while command_name.nil? do
        case arg = args.shift
          when '-h', '--help', nil
            command_name = 'help'
          when '-v', '--version'
            puts "workspace v#{ Workspace::Version::STRING }"
            exit
          when '-d', '--debug'
            @options[ :debug ] = true
          when /^-/
            command_name = 'help'
            command_options << 'unknown_switch' << arg
        else
          command_name = arg.to_s.downcase
          if commands.include?( command_name )
            command_options = args
          else
            command_options << 'unknown_command' << arg.to_s.downcase
            command_name = 'help'
          end
        end
      end
      
      @command = find_command( command_name )
      
      if @command
        @command.process_options!( command_options )
      end
      # if Workspace::CommandManager.has( command_name )
      # end
      # 
      # unless @command
      # end
    end
    # # END
    # ########
    
    # ##############
    # # FROM RUBYGEMS
    # 
    # def process_args(args)
    #   args = args.to_str.split(/\s+/) if args.respond_to?(:to_str)
    #   if args.size == 0
    #     say Gem::Command::HELP
    #     terminate_interaction(1)
    #   end 
    #   case args[0]
    #   when '-h', '--help'
    #     say Gem::Command::HELP
    #     terminate_interaction(0)
    #   when '-v', '--version'
    #     say Gem::RubyGemsVersion
    #     terminate_interaction(0)
    #   when /^-/
    #     alert_error "Invalid option: #{args[0]}.  See 'gem --help'."
    #     terminate_interaction(1)
    #   else
    #     cmd_name = args.shift.downcase
    #     cmd = find_command(cmd_name)
    #     cmd.invoke(*args)
    #   end
    # end
    # 
    # def find_command(cmd_name)
    #   possibilities = find_command_possibilities(cmd_name)
    #   if possibilities.size > 1
    #     raise "Ambiguous command #{cmd_name} matches [#{possibilities.join(', ')}]"
    #   end
    #   if possibilities.size < 1
    #     raise "Unknown command #{cmd_name}"
    #   end
    # 
    #   self[possibilities.first]
    # end
    # 
    # def find_command_possibilities(cmd_name)
    #   len = cmd_name.length
    #   self.command_names.select { |n| cmd_name == n[0,len] }
    # end
    # 
    # private
    # 
    # def load_and_instantiate(command_name)
    #   command_name = command_name.to_s
    #   retried = false
    # 
    #   begin
    #     const_name = command_name.capitalize.gsub(/_(.)/) { $1.upcase }
    #     Gem::Commands.const_get("#{const_name}Command").new
    #   rescue NameError
    #     if retried then
    #       raise
    #     else
    #       retried = true
    #       require "rubygems/commands/#{command_name}_command"
    #       retry
    #     end
    #   end
    # end
    # # END
    # #####
    
    # #####
    # # From script/plugin
    # def parse!(args=ARGV)
    #   general, sub = split_args(args)
    #   options.parse!(general)
    # 
    #   command = general.shift
    #   if command =~ /^(list|discover|install|source|unsource|sources|remove|update|info)$/
    #     command = Commands.const_get(command.capitalize).new(self)
    #     command.parse!(sub)
    #   else
    #     puts "Unknown command: #{command}"
    #     puts options
    #     exit 1
    #   end
    # end
    # 
    # def split_args(args)
    #   left = []
    #   left << args.shift while args[0] and args[0] =~ /^-/
    #   left << args.shift if args[0]
    #   return [left, args]
    # end
    # 
    # def self.parse!(args=ARGV)
    #   Plugin.new.parse!(args)
    # end
    # # END
    # #####
    
    def banner
      return @banner if @banner
      @banner = <<-OUT
      Usage: workspace [-h|-v] command [options]
      
      available commands:
      OUT
      @banner = @banner.split("\n").collect{|l|l.gsub(/^\s+/,'')}.join("\n")
    end
  # 
  #     attr_reader :options
  #     FORMATS = %w{pretty profile progress html autotest}
  #     DEFAULT_FORMAT = 'pretty'
  # 

  # 
  #     def parse_options!(args)
  #       return parse_args_from_profile('default') if args.empty?
  #       args.extend(OptionParser::Arguable)
  # 
  #       args.options do |opts|
  #         opts.banner = "Usage: cucumber [options] FILES|DIRS"
  #         opts.on("-r LIBRARY|DIR", "--require LIBRARY|DIR", "Require files before executing the features.",
  #           "If this option is not specified, all *.rb files that",
  #           "are siblings or below the features will be autorequired",
  #           "This option can be specified multiple times.") do |v|
  #           @options[:require] ||= []
  #           @options[:require] << v
  #         end
  #         opts.on("-l LINE", "--line LINE", "Only execute the scenario at the given line") do |v|
  #           @options[:line] = v
  #         end
  #         opts.on("-s SCENARIO", "--scenario SCENARIO", "Only execute the scenario with the given name.",
  #                                                       "If this option is given more than once, run all",
  #                                                       "the specified scenarios.") do |v|
  #           @options[:scenario_names] ||= []
  #           @options[:scenario_names] << v
  #         end
  #         opts.on("-a LANG", "--language LANG", "Specify language for features (Default: #{@options[:lang]})",
  #           "Available languages: #{Cucumber.languages.join(", ")}",
  #           "Look at #{Cucumber::LANGUAGE_FILE} for keywords") do |v|
  #           @options[:lang] = v
  #         end
  #         opts.on("-f FORMAT", "--format FORMAT", "How to format features (Default: #{DEFAULT_FORMAT})",
  #           "Available formats: #{FORMATS.join(", ")}",
  #           "This option can be specified multiple times.") do |v|
  #           unless FORMATS.index(v)
  #             @error_stream.puts "Invalid format: #{v}\n"
  #             @error_stream.puts opts.help
  #             exit 1
  #           end
  #           @options[:formats][v] ||= []
  #           @options[:formats][v] << @out_stream
  #           @active_format = v
  #         end
  #         opts.on("-o", "--out FILE", "Write output to a file instead of @out_stream.",
  #           "This option can be specified multiple times, and applies to the previously",
  #           "specified --format.") do |v|
  #           @options[:formats][@active_format] ||= []
  #           if @options[:formats][@active_format].last == @out_stream
  #             @options[:formats][@active_format][-1] = File.open(v, 'w')
  #           else
  #             @options[:formats][@active_format] << File.open(v, 'w')
  #           end
  #         end
  #         opts.on("-c", "--[no-]color", "Use ANSI color in the output, if formatters use it.  If",
  #                                       "these options are given multiple times, the last one is",
  #                                       "used.  If neither --color or --no-color is given cucumber",
  #                                       "decides based on your platform and the output destination") do |v|
  #           @options[:color] = v
  #         end
  #         opts.on("-e", "--exclude PATTERN", "Don't run features matching a pattern") do |v|
  #           @options[:excludes] << v
  #         end
  #         opts.on("-p", "--profile PROFILE", "Pull commandline arguments from cucumber.yml.") do |v|
  #           parse_args_from_profile(v)
  #         end
  #         opts.on("-d", "--dry-run", "Invokes formatters without executing the steps.") do
  #           @options[:dry_run] = true
  #         end
  #         opts.on("-n", "--no-source", "Don't show the file and line of the step definition with the steps.") do
  #           @options[:source] = false
  #         end
  #         opts.on("-i", "--no-snippets", "Don't show the snippets for pending steps") do
  #           @options[:snippets] = false
  #         end
  #         opts.on("-q", "--quiet", "Don't show any development aid information") do
  #           @options[:snippets] = false
  #           @options[:source] = false
  #         end
  #         opts.on_tail("--version", "Show version") do
  #           puts VERSION::STRING
  #           exit
  #         end
  #         opts.on_tail("--help", "You're looking at it") do
  #           puts opts.help
  #           exit
  #         end
  #       end.parse!
  # 
  #       if @options[:formats].empty?
  #         @options[:formats][DEFAULT_FORMAT] = [@out_stream]
  #       end
  # 
  #       # Whatever is left after option parsing is the FILE arguments
  #       @paths += args
  #     end
  # 
  #     def parse_args_from_profile(profile)
  #       unless File.exist?('cucumber.yml')
  #         return exit_with_error("cucumber.yml was not found.  Please define your '#{profile}' and other profiles in cucumber.yml.\n"+
  #                                "Type 'cucumber --help' for usage.\n")
  #       end
  #       
  #       require 'yaml'
  #       cucumber_yml = YAML::load(IO.read('cucumber.yml'))
  #       args_from_yml = cucumber_yml[profile]
  #       if args_from_yml.nil?
  #         exit_with_error <<-END_OF_ERROR
  # Could not find profile: '#{profile}'
  # 
  # Defined profiles in cucumber.yml:
  #   * #{cucumber_yml.keys.join("\n  * ")}
  #         END_OF_ERROR
  #       elsif !args_from_yml.is_a?(String)
  #         exit_with_error "Profiles must be defined as a String.  The '#{profile}' profile was #{args_from_yml.inspect} (#{args_from_yml.class}).\n"
  #       else
  #         parse_options!(args_from_yml.split(' '))
  #       end
  #     end
  # 
  #     def execute!(step_mother, executor, features)
  #       Term::ANSIColor.coloring = @options[:color] unless @options[:color].nil?
  #       Cucumber.load_language(@options[:lang])
  #       executor.formatters = build_formatter_broadcaster(step_mother)
  #       require_files
  #       load_plain_text_features(features)
  #       executor.line = @options[:line].to_i if @options[:line]
  #       executor.scenario_names = @options[:scenario_names] if @options[:scenario_names]
  #       executor.visit_features(features)
  #       exit 1 if executor.failed
  #     end
  # 
  #     private
  # 
  #     # Requires files - typically step files and ruby feature files.
  #     def require_files
  #       ARGV.clear # Shut up RSpec
  #       require "cucumber/treetop_parser/feature_#{@options[:lang]}"
  #       require "cucumber/treetop_parser/feature_parser"
  # 
  #       requires = @options[:require] || feature_dirs
  #       libs = requires.map do |path|
  #         path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
  #         File.directory?(path) ? Dir["#{path}/**/*.rb"] : path
  #       end.flatten.uniq
  #       libs.each do |lib|
  #         begin
  #           require lib
  #         rescue LoadError => e
  #           e.message << "\nFailed to load #{lib}"
  #           raise e
  #         end
  #       end
  #     end
  # 
  #     def feature_files
  #       potential_feature_files = @paths.map do |path|
  #         path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
  #         path = path.chomp('/')
  #         File.directory?(path) ? Dir["#{path}/**/*.feature"] : path
  #       end.flatten.uniq
  # 
  #       @options[:excludes].each do |exclude|
  #         potential_feature_files.reject! do |path|
  #           path =~ /#{Regexp.escape(exclude)}/
  #         end
  #       end
  # 
  #       potential_feature_files
  #     end
  # 
  #     def feature_dirs
  #       feature_files.map{|f| File.directory?(f) ? f : File.dirname(f)}.uniq
  #     end
  # 
  #     def load_plain_text_features(features)
  #       parser = TreetopParser::FeatureParser.new
  # 
  #       feature_files.each do |f|
  #         features << parser.parse_feature(f)
  #       end
  #     end
  # 
  #     def build_formatter_broadcaster(step_mother)
  #       formatter_broadcaster = Broadcaster.new
  #       @options[:formats].each do |format, output_list|
  #         output_broadcaster = build_output_broadcaster(output_list)
  #         case format
  #         when 'pretty'
  #           formatter_broadcaster.register(Formatters::PrettyFormatter.new(output_broadcaster, step_mother, @options))
  #         when 'progress'
  #           formatter_broadcaster.register(Formatters::ProgressFormatter.new(output_broadcaster))
  #         when 'profile'
  #           formatter_broadcaster.register(Formatters::ProfileFormatter.new(output_broadcaster, step_mother))
  #         when 'html'
  #           formatter_broadcaster.register(Formatters::HtmlFormatter.new(output_broadcaster, step_mother))
  #         when 'autotest'
  #           formatter_broadcaster.register(Formatters::AutotestFormatter.new(output_broadcaster))
  #         else
  #           raise "Unknown formatter: #{@options[:format]}"
  #         end
  #       end
  #       formatter_broadcaster
  #     end
  # 
  #     def build_output_broadcaster(output_list)
  #       output_broadcaster = Broadcaster.new
  #       output_list.each do |output|
  #         output_broadcaster.register(output)
  #       end
  #       output_broadcaster
  #     end
  #     
  #   private
  # 
  #     def exit_with_error(error_message)
  #       @error_stream << error_message
  #       Kernel.exit 1
  #     end
  
  end
end
