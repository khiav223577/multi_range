# frozen_string_literal: true

require 'test_helper'

class MultiRangeTest < Minitest::Test
  def setup
    @multi_range = MultiRange.new([0..2, 4..5])
    @empty_range = MultiRange.new([])
  end

  def test_that_it_has_a_version_number
    refute_nil ::MultiRange::VERSION
  end

  def test_integer_to_range
    assert_equal [1..1, 4..6, 9..9], MultiRange.new([1, 4..6, 9]).ranges
  end

  def test_float_to_range
    assert_equal [1.2..1.6, 1.8..1.8], MultiRange.new([1.2..1.6, 1.8]).ranges
  end

  def test_unsorted_ranges
    assert_equal @multi_range.ranges, MultiRange.new([4..5, 0..2]).ranges
    assert_equal [12..12, 20..20, 21..21, 24..26, 30..31], MultiRange.new([30..31, 12, 24..26, 21, 20]).ranges
  end

  def test_merge_overlaps
    assert_equal [], @empty_range.merge_overlaps.ranges

    multi_range = MultiRange.new([1, 2, 4..6, 7, 8..12])
    assert_equal [1..2, 4..12], multi_range.merge_overlaps.ranges

    multi_range = MultiRange.new([1, 2, 3, 4..6, 7, 9, 11..13, 14..16, 17, 19..20])
    assert_equal [1..7, 9..9, 11..17, 19..20], multi_range.merge_overlaps.ranges
  end

  def test_merge_overlaps_with_float_range
    multi_range = MultiRange.new([1.2..1.5, 1.7..1.9, 1.8..2.2])
    assert_equal [1.2..1.5, 1.7..2.2], multi_range.merge_overlaps.ranges
  end

  def test_excluded_end_value_will_be_merged
    multi_range = MultiRange.new([1...3, 3..4])
    assert_equal [1..4], multi_range.merge_overlaps.ranges

    multi_range = MultiRange.new([1.1...1.2, 1.2..1.4])
    assert_equal [1.1..1.4], multi_range.merge_overlaps.ranges
  end

  def test_float_value_with_exclude_end
    multi_range = MultiRange.new([1.1...1.3, 1.2...1.4])
    assert_equal [1.1...1.4], multi_range.merge_overlaps.ranges
  end

  def test_merge_overlaps_with_unbounded_ranges
    skip if not SUPPORT_UNBOUNDED_RANGE_SYNTAX

    multi_range = MultiRange.new([6..nil, nil..1, 5...nil, nil...2])
    assert_equal [nil...2, 5...nil], multi_range.merge_overlaps.ranges

    multi_range = MultiRange.new([6...nil, nil...1, 5..nil, nil..2])
    assert_equal [nil..2, 5..nil], multi_range.merge_overlaps.ranges

    multi_range = MultiRange.new([nil..5, 3..nil])
    assert_equal [nil..Float::INFINITY], multi_range.merge_overlaps.ranges
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
    expect_to_receive(RouletteWheelSelection, :sample, { 4..5 => 2, 0..2 => 3 }, 0..2) do
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
    assert_equal [0, 2, 4, 7, 9], @multi_range.map.with_index{|s, idx| s + idx }
    assert_equal [], @empty_range.map.with_index{|s, idx| s + idx }
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
    assert_equal({ 0 => 0, 1 => 1, 2 => 2, 4 => 3, 5 => 4 }, @multi_range.index_with.with_index.to_h)
    assert_equal({}, @empty_range.index_with.with_index.to_h)
  end

  def test_to_a
    assert_equal [0, 1, 2, 4, 5], @multi_range.to_a
    assert_equal [], @empty_range.to_a
  end

  def test_min
    assert_equal 0, @multi_range.min
    assert_nil @empty_range.min
  end

  def test_max
    assert_equal 5, @multi_range.max
    assert_nil @empty_range.max
  end

  def test_ranges_are_frozen
    assert_frozen_error{ @multi_range.ranges << 1 }
    assert_frozen_error{ @empty_range.ranges << 1 }
  end
end
