begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  require 'spec'
end
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
  exit(0)
end

desc "Run all the specs in spec directory"
Spec::Rake::SpecTask.new( :spec ) do |t|
  t.spec_opts = [ '--options', "spec/spec.opts" ]
  t.spec_files = FileList[ 'spec/**/*_spec.rb' ]
end

namespace :spec do
  desc "Run all specs in spec directory with RCov"
  Spec::Rake::SpecTask.new( :rcov ) do |t|
    t.spec_opts = [ '--options', "spec/spec.opts" ]
    t.spec_files = FileList[ 'spec/**/*_spec.rb' ]
    t.rcov = true
    # t.rcov_opts = [ '--exclude', "spec/*" ]
    t.rcov_opts = [ '--exclude', "spec" ]
  end

  desc "Print Specdoc for all specs in spec directory"
  Spec::Rake::SpecTask.new( :doc ) do |t|
    t.spec_opts = [ "--format", "specdoc", "--dry-run" ]
    # t.spec_opts = [ "--format", "specdoc" ]
    t.spec_files = FileList[ 'spec/**/*_spec.rb' ]
  end

  # [ :models, :controllers, :views, :helpers, :lib ].each do |sub|
  #   desc "Run the code examples in spec/#{sub}"
  #   Spec::Rake::SpecTask.new( sub ) do |t|
  #     t.spec_opts = [ '--options', "spec/spec.opts" ]
  #     t.spec_files = FileList[ 'spec/#{sub}/**/*_spec.rb' ]
  #   end
  # end
end
