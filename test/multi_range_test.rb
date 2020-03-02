require 'test_helper'

class MultiRangeTest < Minitest::Test
  def setup
    @multi_range = MultiRange.new([0..2, 4..5])
    @empty_range = MultiRange.new([])
  end

  def test_that_it_has_a_version_number
    refute_nil ::MultiRange::VERSION
  end

  def test_size
    assert_equal 5, @multi_range.size
    assert_equal 0, @empty_range.size
  end

  def test_any?
    assert_equal true, @multi_range.any?
    assert_equal false, @empty_range.any?
  end

  def test_sample
    srand(437598)
    assert_equal 1, @multi_range.sample
    assert_nil @empty_range.sample
  end

  def test_each
    array1 = []
    array2 = []
    @multi_range.each{|s| array1 << s }
    @empty_range.each{|s| array2 << s }

    assert_equal [0, 1, 2, 4, 5], array1
    assert_equal [], array2
  end
end
