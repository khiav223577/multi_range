require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'backports/2.4.0/enumerable/sum' if not Array.method_defined?(:sum)
require 'multi_range'

require 'minitest/autorun'

def assert_before_and_after(test_proc, subject_proc, expected_value)
  before = test_proc.call
  subject_proc.call
  after = test_proc.call
  assert_equal expected_value, before: before, after: after
end
