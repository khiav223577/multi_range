# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'test_frameworks'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'backports/2.1.0/enumerable/to_h' if not Enumerable.method_defined?(:to_h)
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

def expect_to_receive(obj, method, expected_args, return_value, &block)
  obj.stub(method, proc{|args|
    assert_equal(expected_args, args)
    next return_value
  }, &block)
end

def assert_frozen_error
  frozen_class = case
                 when RUBY_VERSION < '2'   ; TypeError
                 when RUBY_VERSION < '2.5' ; RuntimeError
                 else                      ; FrozenError
                 end

  assert_raises(frozen_class){ yield }
end

def assert_performant
  performance_budget_in_seconds = 0.1
  a = Time.now
  yield
  b = Time.now
  assert(b - a < performance_budget_in_seconds)
end
