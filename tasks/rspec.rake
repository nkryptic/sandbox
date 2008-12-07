begin
  require 'spec'
  require 'spec/rake/spectask'
  
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

    desc "Run all the specs in spec directory individually"
    task :deps do
      individual_specs = Dir["spec/**/*_spec.rb"]
      individual_specs.each do |single_spec|
        if not system "spec #{single_spec} --options spec/spec.opts &> /dev/null"
          puts "Dependency Issues: #{single_spec}"
        else
          puts "OK: #{single_spec}"
        end
      end
    end
  end
  
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
end
