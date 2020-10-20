# frozen_string_literal: true

require 'test_helper'

class ContainOverlapTest < Minitest::Test
  def setup
  end

  def test_empty_range
    assert_equal false, MultiRange.new([]).contain_overlaps?
  end

  def test_when_have_only_one_range
    assert_equal false, MultiRange.new([-9999, 9999]).contain_overlaps?
  end

  def test_when_range_have_excluded_right_value
    assert_equal false, MultiRange.new([0...5, 5..10, 20..50]).contain_overlaps?
    assert_equal true, MultiRange.new([0..5, 5..10, 20..50]).contain_overlaps?
  end

  def test_when_full_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, 50..120]).contain_overlaps?
  end

  def test_when_right_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, -10..20]).contain_overlaps?
  end

  def test_when_left_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, 330..400]).contain_overlaps?
  end

  def test_when_not_cover_excluded_range
    assert_equal true, MultiRange.new([0...360, -30..400]).contain_overlaps?
  end

  def test_float
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.65]).contain_overlaps?
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.69]).contain_overlaps?
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6...1.7]).contain_overlaps?
    assert_equal true, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.7]).contain_overlaps?
    assert_equal true, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..1.71]).contain_overlaps?

    val = 1.7 - Float::EPSILON
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6...val]).contain_overlaps?
    assert_equal false, MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2, 1.6..val]).contain_overlaps?
  end
end
