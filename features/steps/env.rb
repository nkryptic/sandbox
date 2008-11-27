require File.dirname(__FILE__) + "/../../lib/sandbox"

# gem 'cucumber'
# require 'cucumber'
# gem 'rspec'
# require 'spec'

begin
  require 'cucumber'
  require 'spec'
rescue LoadError
  require 'rubygems'
  require 'cucumber'
  require 'spec'
end