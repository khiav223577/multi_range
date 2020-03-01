require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'backports/2.1.0/enumerable/to_h' if not Enumerable.method_defined?(:to_h)
require 'backports/2.4.0/enumerable/sum' if not Array.method_defined?(:sum)
if not Range.method_defined?(:size)
  require 'backports/1.9.2/float/infinity' # It's a bug in backports: https://github.com/marcandre/backports/pull/144
  require 'backports/2.0.0/range/size'
end

require 'multi_range'

require 'minitest/autorun'

def assert_before_and_after(test_proc, subject_proc, expected_value)
  before = test_proc.call
  subject_proc.call
  after = test_proc.call
  assert_equal expected_value, :before => before, :after => after
end
