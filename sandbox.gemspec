# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sandbox}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Radford"]
  s.date = %q{2008-12-06}
  s.default_executable = %q{sandbox}
  s.description = %q{Create virtual ruby/rubygems sandboxes.}
  s.email = %q{nkryptic@gmail.com}
  s.executables = ["sandbox"]
  s.extra_rdoc_files = ["CHANGELOG", "TODO", "README.rdoc", "tasks/rspec.rake", "tasks/cucumber.rake", "tasks/gem.rake", "tasks/dcov.rake", "lib/sandbox.rb", "lib/sandbox/installer.rb", "lib/sandbox/cli.rb", "lib/sandbox/templates/activate_sandbox.erb", "lib/sandbox/version.rb", "lib/sandbox/errors.rb", "bin/sandbox"]
  s.files = ["sandbox.gemspec", "CHANGELOG", "TODO", "spec/sandbox/errors_spec.rb", "spec/sandbox/cli_spec.rb", "spec/sandbox/installer_spec.rb", "spec/sandbox_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "Manifest", "features/steps/common.rb", "features/steps/env.rb", "features/development.feature", "README.rdoc", "tasks/rspec.rake", "tasks/cucumber.rake", "tasks/gem.rake", "tasks/dcov.rake", "Rakefile", "lib/sandbox.rb", "lib/sandbox/installer.rb", "lib/sandbox/cli.rb", "lib/sandbox/templates/activate_sandbox.erb", "lib/sandbox/version.rb", "lib/sandbox/errors.rb", "bin/sandbox"]
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
    else
    end
  else
  end
end
