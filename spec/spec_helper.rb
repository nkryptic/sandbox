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
  
  def capture(*streams)
    results = []
    streams.collect! do |stream|
      stream = stream.to_s
    end
    begin
      streams.each do |stream|
        eval "$#{stream} = StringIO.new"
      end
      yield
      streams.each do |stream|
        results << eval("$#{stream}").string
      end
    ensure
      streams.each do |stream|
        eval("$#{stream} = #{stream.upcase}")
      end
    end
 
    return *results
  end
  
  alias silence capture
  
end
