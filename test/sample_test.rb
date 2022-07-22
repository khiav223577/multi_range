# frozen_string_literal: true

require 'test_helper'

class SampleTest < Minitest::Test
  def setup
    srand(123456789)
  end

  def test_empty_range
    assert_nil MultiRange.new([]).sample
  end

  def test_one_element_range
    assert_equal 28, MultiRange.new([28..28]).sample
  end

  def test_ranges
    assert_equal 92, MultiRange.new([28..28, 90..100]).sample
  end
end
