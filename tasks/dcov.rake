begin
  require 'dcov'
rescue LoadError
  require 'rubygems'
  begin
    require 'dcov'
  rescue LoadError
    puts <<-EOS
To generate documentation coverage with dcov you must install dcov gem:
    gem install dcov
EOS
    exit( 0 )
  end
end

desc "Generate coverage report for lib directory"
task :dcov do
  root      = Dir.pwd
  dcov_dir  = File.join( root, 'coverage' )
  lib_dir   = File.join( root, 'lib' )
  
  unless File.directory?( lib_dir )
    puts "Aborting: please run from the root of the project"
    exit( 0 )
  end
  
  # files     = Dir[ File.join( lib_dir, '**', '*.rb' ) ]
  options   = {
    :path => dcov_dir,
    :output_format => 'html',
    :files => lib_dir
    # :files => files
  }
  
  Dir.mkdir( dcov_dir ) unless File.directory?( dcov_dir )
  Dcov::Analyzer.new( options )
end
