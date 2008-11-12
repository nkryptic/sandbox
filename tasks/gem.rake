
desc "Create this gem's .gemspec file"
task :gemspec do
  Rake::Task[ 'build_gemspec' ].invoke
end