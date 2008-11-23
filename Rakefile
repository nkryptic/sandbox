require 'rubygems'
require 'rake'
 
require 'lib/workspace' unless defined? Workspace
 
begin
  require 'echoe'
  
  Echoe.new( 'workspace', Workspace::Version::STRING ) do |p|  
    # p.rubyforge_name            = 'nkryptic'
    # p.summary                   = "Create virtual ruby/rubygems workspaces."
    p.description               = "Create virtual ruby/rubygems workspaces."
    p.url                       = "http://github.com/nkryptic/workspace"
    p.author                    = "Jacob Radford"
    p.email                     = "nkryptic@gmail.com"
    p.ignore_pattern            = [ "tmp/*", "script/*" ]
    p.development_dependencies  = [
                                    'echoe ~> 3.0',
                                    'rspec ~> 1.1.0',
                                    'mocha ~> 0.9',
                                  ]
    # p.dependencies = ['ParseTree >=2.1.1', 'ruby2ruby >=1.1.8']
  end
  
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
end

Dir[ "#{File.dirname(__FILE__)}/tasks/*.rake" ].sort.each { |ext| load ext }
 
# desc 'Generate RDoc documentation for Workspace.'
# Rake::RDocTask.new( :rdoc ) do |rdoc|
#   files = [ 'README', 'LICENSE', 'lib/**/*.rb' ]
#   rdoc.rdoc_files.add( files )
#   rdoc.main = "README" # page to start on
#   rdoc.title = "workspace"
#   # rdoc.template = File.exists?( t="/Users/chris/ruby/projects/err/rock/template.rb" ) ? t : "/var/www/rock/template.rb"
#   rdoc.rdoc_dir = 'doc' # rdoc output folder
#   rdoc.options << '--inline-source'
# end