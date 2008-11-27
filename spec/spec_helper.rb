# begin
#   require 'spec'
# rescue LoadError
#   require 'rubygems'
#   # gem 'rspec'
#   require 'spec'
# end
# 
# $:.unshift( File.dirname( __FILE__ ) + '/../lib' )

$:.unshift( File.dirname( __FILE__ ) + '/../lib' )
require 'rubygems'
require 'mocha'
require 'spec'
require 'stringio'
require 'ostruct'

require 'workspace'

Spec::Runner.configure do |config|
  # == Mock Framework
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  
  def capture
    results = OpenStruct.new
    
    begin
      $stdout = StringIO.new
      $stderr = StringIO.new
      yield
      results.stdout = $stdout.string
      results.stderr = $stderr.string
    ensure
      $stdout = STDOUT
      $stderr = STDERR
    end
 
    return results
  end
  
  alias silence capture
  
end


## thanks to Jay Fields (http://blog.jayfields.com/2007/11/ruby-testing-private-methods.html)
class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    begin
      self.class_eval { public *saved_private_instance_methods }
      yield
    ensure
      self.class_eval { private *saved_private_instance_methods }
    end
  end
end

