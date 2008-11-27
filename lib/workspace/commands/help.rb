
# require 'workspace/command'

class Workspace::Commands::HelpCommand < Workspace::Command
  
  ## CLASS METHODS
  class << self
  end
  ## END CLASS METHODS
  
  ## PUBLIC INSTANCE METHODS
  public
    def initialize
      super( 'help', "Provide help on general usage or individual commands" )
    end
    
    def execute!
      arg = options[ :args ].first
      case arg
        when /^commands/i
          raise
      else
        show_application_help
      end
    end
    
    def show_application_help
      puts %{
        
        Workspace will create a virtual environment for development.
        This is a basic help message with pointers to more information.
        
          Usage:
            workspace -h/--help
            workspace -v/--version
            workspace command [arguments...] [options...]
          
          Further help:
            workspace help commands            list all 'workspace' commands
            workspace help <COMMAND>           show help on COMMAND
          
          Basic commands:
            init          Create a new workspace
            list          List downloaded or remotely available ruby/rubygems versions
            help          Show detailed help on a specific command
      }.gsub(/^\s{6}/, "")
    end
    
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
  ## END PUBLIC INSTANCE METHODS
  
  
  ## PRIVATE INSTANCE METHODS
  private
    
  ## END PRIVATE INSTANCE METHODS
  
end