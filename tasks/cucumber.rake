begin
  require 'cucumber'
  require 'cucumber/rake/task'
  # Try these:
  #
  # rake features
  # rake features PROFILE=html
  Cucumber::Rake::Task.new do |t|
    # profile         = ENV[ 'PROFILE' ] || 'default'
    # t.cucumber_opts = "--profile #{profile}"
    t.cucumber_opts = "--format pretty"
  end
rescue LoadError
  puts <<-EOS
  To use cucumber for testing you must install cucumber gem:
    gem install cucumber

EOS
end