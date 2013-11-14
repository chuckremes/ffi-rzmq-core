
require File.expand_path(
File.join(File.dirname(__FILE__), %w[.. lib ffi-rzmq-core]))

def jruby?
  RUBY_PLATFORM =~ /java/
end

