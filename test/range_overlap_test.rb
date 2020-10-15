# frozen_string_literal: true

require 'test_helper'

class RangeOverlapTest < Minitest::Test
  def setup
    @degree_range = MultiRange.new([0...360])
    @empty_range = MultiRange.new([])
    @multi_range = MultiRange.new([0..100, 200..300, 500..600])
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
  end

  def test_when_left_cover_excluded_range
    assert_equal true, @degree_range.overlaps?(330..400)
  end

  def test_when_not_cover_excluded_range
    assert_equal true, @degree_range.overlaps?(-30..400)
  end

  def test_multi_range
    assert_equal true, @multi_range.overlaps?(50..550)
  end

  def test_difference_other_multi_range
    assert_equal true, @multi_range.overlaps?(MultiRange.new([50..60, 110..120, 180..550, 700]))
  end
end