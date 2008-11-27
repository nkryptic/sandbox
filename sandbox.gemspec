# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sandbox}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Radford"]
  s.date = %q{2008-11-27}
  s.default_executable = %q{sandbox}
  s.description = %q{Create virtual ruby/rubygems sandboxes.}
  s.email = %q{nkryptic@gmail.com}
  s.executables = ["sandbox"]
  s.extra_rdoc_files = ["CHANGELOG", "TODO", "README.rdoc", "tasks/rspec.rake", "tasks/cucumber.rake", "tasks/gem.rake", "tasks/dcov.rake", "lib/sandbox.rb", "lib/sandbox/command_manager.rb", "lib/sandbox/cli.rb", "lib/sandbox/version.rb", "lib/sandbox/command.rb", "lib/sandbox/commands/help.rb", "lib/sandbox/commands/init.rb", "bin/sandbox"]
  s.files = ["sandbox.gemspec", "CHANGELOG", "TODO", "spec/sandbox/cli_spec.rb", "spec/sandbox/command_manager_spec.rb", "spec/sandbox/command_spec.rb", "spec/sandbox/commands/init_spec.rb", "spec/sandbox/commands/help_spec.rb", "spec/sandbox_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "Manifest", "features/steps/common.rb", "features/steps/env.rb", "features/development.feature", "README.rdoc", "tasks/rspec.rake", "tasks/cucumber.rake", "tasks/gem.rake", "tasks/dcov.rake", "Rakefile", "lib/sandbox.rb", "lib/sandbox/command_manager.rb", "lib/sandbox/cli.rb", "lib/sandbox/version.rb", "lib/sandbox/command.rb", "lib/sandbox/commands/help.rb", "lib/sandbox/commands/init.rb", "bin/sandbox"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nkryptic/sandbox}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sandbox", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sandbox}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Create virtual ruby/rubygems sandboxes.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, ["~> 0", "= 3.0"])
      s.add_development_dependency(%q<rspec>, ["~> 0", "= 1.1.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0", "= 0.9"])
    else
      s.add_dependency(%q<echoe>, ["~> 0", "= 3.0"])
      s.add_dependency(%q<rspec>, ["~> 0", "= 1.1.0"])
      s.add_dependency(%q<mocha>, ["~> 0", "= 0.9"])
    end
  else
    s.add_dependency(%q<echoe>, ["~> 0", "= 3.0"])
    s.add_dependency(%q<rspec>, ["~> 0", "= 1.1.0"])
    s.add_dependency(%q<mocha>, ["~> 0", "= 0.9"])
  end
end
