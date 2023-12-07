# frozen_string_literal: true

require 'test_helper'

class RangeOverlapTest < Minitest::Test
  def setup
    @degree_range = MultiRange.new([0...360])
    @empty_range = MultiRange.new([])
    @multi_range = MultiRange.new([0..100, 200..300, 500..600])
    @float_range = MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2])
  end

  def test_empty_range
    assert_equal false, @empty_range.overlaps?(5..10)
    assert_equal false, @empty_range.overlaps?(-999..999)
  end

  def test_when_full_cover_excluded_range
    assert_equal true, @degree_range.overlaps?(50..120)
  end

  def test_when_right_cover_excluded_range
    assert_equal true, @degree_range.overlaps?(-10..20)

    if SUPPORT_UNBOUNDED_RANGE_SYNTAX
      assert_equal true, @degree_range.overlaps?(nil..20)
      assert_equal true, @degree_range.overlaps?(nil...20)
    end
  end

  def test_when_left_cover_excluded_range
    assert_equal true, @degree_range.overlaps?(330..400)

    if SUPPORT_UNBOUNDED_RANGE_SYNTAX
      assert_equal true, @degree_range.overlaps?(330..nil)
      assert_equal true, @degree_range.overlaps?(330...nil)
    end
  end

  def test_when_not_cover_excluded_range
    assert_equal true, @degree_range.overlaps?(-30..400)
  end

  def test_when_smaller_and_not_overlap
    assert_equal false, @degree_range.overlaps?(-30..-10)
  end

  def test_when_larger_and_not_overlap
    assert_equal false, @degree_range.overlaps?(370..400)
  end

  def test_multi_range
    assert_equal true, @multi_range.overlaps?(50..550)
  end

  def test_other_multi_range
    assert_equal true, @multi_range.overlaps?(MultiRange.new([50..60, 110..120, 180..550, 700]))
  end

  def test_other_multi_range_and_not_overlap
    assert_equal false, @multi_range.overlaps?(MultiRange.new([-10..-5, 105..199, 400, 700..900]))
  end

  def test_float
    assert_equal false, @float_range.overlaps?(1.6..1.65)
    assert_equal false, @float_range.overlaps?(1.6..1.69)
    assert_equal false, @float_range.overlaps?(1.6...1.7)
    assert_equal true, @float_range.overlaps?(1.6..1.7)
    assert_equal true, @float_range.overlaps?(1.6..1.71)

    val = 1.7 - Float::EPSILON
    assert_equal false, @float_range.overlaps?(1.6..val)
    assert_equal false, @float_range.overlaps?(1.6...val)
  end

  def test_unbounded_ranges
    skip if not SUPPORT_UNBOUNDED_RANGE_SYNTAX

    assert_equal true, MultiRange.new([nil..100]).overlaps?(MultiRange.new([50...nil]))
    assert_equal true, MultiRange.new([nil..50]).overlaps?(MultiRange.new([50...nil]))
    assert_equal false, MultiRange.new([nil...50]).overlaps?(MultiRange.new([50...nil]))
  end
end
