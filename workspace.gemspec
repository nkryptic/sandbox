# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{workspace}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Radford"]
  s.date = %q{2008-11-22}
  s.default_executable = %q{workspace}
  s.description = %q{Create virtual ruby/rubygems workspaces.}
  s.email = %q{nkryptic@gmail.com}
  s.executables = ["workspace"]
  s.extra_rdoc_files = ["CHANGELOG", "TODO", "README.rdoc", "tasks/rspec.rake", "tasks/cucumber.rake", "tasks/gem.rake", "lib/workspace.rb", "lib/workspace/command_manager.rb", "lib/workspace/cli.rb", "lib/workspace/version.rb", "lib/workspace/options.rb", "lib/workspace/command.rb", "bin/workspace"]
  s.files = ["CHANGELOG", "TODO", "spec/spec.opts", "spec/workspace_spec.rb", "spec/workspace/options_spec.rb", "spec/workspace/cli_spec.rb", "spec/workspace/command_manager_spec.rb", "spec/workspace/command_spec.rb", "spec/spec_helper.rb", "Manifest", "features/steps/common.rb", "features/steps/env.rb", "features/development.feature", "README.rdoc", "workspace.gemspec", "tasks/rspec.rake", "tasks/cucumber.rake", "tasks/gem.rake", "Rakefile", "lib/workspace.rb", "lib/workspace/command_manager.rb", "lib/workspace/cli.rb", "lib/workspace/version.rb", "lib/workspace/options.rb", "lib/workspace/command.rb", "bin/workspace"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nkryptic/workspace}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Workspace", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nkryptic}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Create virtual ruby/rubygems workspaces.}

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
