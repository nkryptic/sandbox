begin
  require 'cucumber'
rescue LoadError
  require 'rubygems'
  require 'cucumber'
end
begin
  require 'cucumber/rake/task'
rescue LoadError
  puts <<-EOS
To use cucumber for testing you must install cucumber gem:
    gem install cucumber
EOS
  exit( 0 )
end
 
# Try these:
#
# rake features
# rake features PROFILE=html
Cucumber::Rake::Task.new do |t|
  # profile         = ENV[ 'PROFILE' ] || 'default'
  # t.cucumber_opts = "--profile #{profile}"
  t.cucumber_opts = "--format pretty"
end