require 'rubygems'
require 'rake'

require_relative 'lib/sandbox' unless defined? Sandbox
 
begin
  require 'echoe'
  
  Echoe.new( 'sandbox', Sandbox::Version::STRING ) do |p|  
    # p.rubyforge_name            = 'nkryptic'
    # p.summary                   = "Create virtual ruby/rubygems sandboxes."
    p.description               = "Create virtual ruby/rubygems sandboxes."
    p.url                       = "http://github.com/nkryptic/sandbox"
    p.author                    = "Jacob Radford"
    p.email                     = "nkryptic@gmail.com"
    p.ignore_pattern            = [ "tmp/*", "script/*" ]
    p.rdoc_pattern              = /^(lib|bin|ext).*(\.rb)$|^README|^CHANGELOG|^TODO|^LICENSE|^COPYING$/
    p.runtime_dependencies      = []
    p.development_dependencies  = [
                                    # 'echoe    ~>3.0',
                                    # 'dcov     ~>0.2',
                                    # 'rcov     ~>0.8',
                                    # 'rspec    ~>1.1.0',
                                    # 'cucumber ~>0.1.0',
                                    # 'mocha    ~>0.9',
                                  ]
    # Version Specification
    # 3 and up,         ">= 3"
    # 3.y.z,            "~> 3.0"
    # 3.0.z,            "~> 3.0.0"
    # 3.5.z to <4.0,    "~> 3.5"
    # 3.5.z to <3.6,    "~> 3.5.0"
    
    # p.dependencies = ['ParseTree >=2.1.1', 'ruby2ruby >=1.1.8']
  end
  
  desc "Create this gem's .gemspec file"
  task :gemspec do
    Rake::Task[ 'build_gemspec' ].invoke
  end
  
rescue LoadError => boom
  puts <<-EOS
  You are missing a dependency required for meta-operations on this gem. Try:
    gem install echoe

EOS
  # puts "You are missing a dependency required for meta-operations on this gem."
  # puts "#{boom.to_s.capitalize}."
end

Dir[ "#{File.dirname(__FILE__)}/tasks/*.rake" ].sort.each { |ext| load ext }
 
# desc 'Generate RDoc documentation for Sandbox.'
# Rake::RDocTask.new( :rdoc ) do |rdoc|
#   files = [ 'README', 'LICENSE', 'lib/**/*.rb' ]
#   rdoc.rdoc_files.add( files )
#   rdoc.main = "README" # page to start on
#   rdoc.title = "sandbox"
#   # rdoc.template = File.exist?( t="/Users/chris/ruby/projects/err/rock/template.rb" ) ? t : "/var/www/rock/template.rb"
#   rdoc.rdoc_dir = 'doc' # rdoc output folder
#   rdoc.options << '--inline-source'
# end