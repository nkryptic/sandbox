begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  # gem 'rspec'
  require 'spec'
end

$:.unshift( File.dirname( __FILE__ ) + '/../lib' )
require 'workspace'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end