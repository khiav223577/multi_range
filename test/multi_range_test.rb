require 'test_helper'

class MultiRangeTest < Minitest::Test
  def setup
    @degree_range = MultiRange.new([0...360])
    @empty_range = MultiRange.new([])
    srand(437598)
  end

  def test_that_it_has_a_version_number
    refute_nil ::MultiRange::VERSION
  end

  def test_size
    assert_equal 360, @degree_range.size
    assert_equal 0, @empty_range.size
  end

  def test_any?
    assert_equal true, @degree_range.any?
    assert_equal false, @empty_range.any?
  end

  def test_sample
    srand(437598)
    assert_equal 41, @degree_range.sample
    assert_nil @empty_range.sample
  end
end
