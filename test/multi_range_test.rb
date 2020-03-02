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
    expect_to_receive(RouletteWheelSelection, :sample, { 4..5 => 2, 0..2 => 3}, 0..2) do
      assert_equal 0, @multi_range.sample
    end

    assert_nil @empty_range.sample
  end

  def test_each_with_block
    array1 = []
    array2 = []

    @multi_range.each{|s| array1 << s }
    @empty_range.each{|s| array2 << s }

    assert_equal [0, 1, 2, 4, 5], array1
    assert_equal [], array2
  end

  def test_each_with_chaining
    assert_equal [0, 1, 2, 4, 5], @multi_range.each.to_a
    assert_equal [], @empty_range.each.to_a
  end

  def test_map
    assert_equal [0, 2, 4, 8, 10], @multi_range.map{|s| s * 2 }
    assert_equal [], @empty_range.map{|s| s * 2 }
  end

  def test_map_with_chaining
    assert_equal [10, 12, 14, 17, 19], @multi_range.map.with_index(10){|s, idx| s + idx }
    assert_equal [], @empty_range.map.with_index(10){|s, idx| s + idx }
  end

  def test_index_with_with_default_value
    assert_equal({ 0 => 'a', 1 => 'a', 2 => 'a', 4 => 'a', 5 => 'a' }, @multi_range.index_with('a'))
    assert_equal({}, @empty_range.index_with('a'))
  end

  def test_index_with_with_block
    assert_equal({ 0 => 0, 1 => 2, 2 => 4, 4 => 8, 5 => 10 }, @multi_range.index_with{|s| s * 2 })
    assert_equal({}, @empty_range.index_with{|s| s * 2 })
  end

  def test_index_with_with_chaining
    assert_equal({ 0 => 10, 1 => 11, 2 => 12, 4 => 13, 5 => 14 }, @multi_range.index_with.with_index(10).to_h)
    assert_equal({}, @empty_range.index_with.with_index(10).to_h)
  end
end
