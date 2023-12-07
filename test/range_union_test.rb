# frozen_string_literal: true

require 'test_helper'

class RangeUnionTest < Minitest::Test
  def setup
    @degree_range = MultiRange.new([0...360])
    @empty_range = MultiRange.new([])
    @multi_range = MultiRange.new([0..100, 200..300, 500..600])
    @float_range = MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2])
  end

  def test_empty_range
    assert_before_and_after(
      proc{ @empty_range.ranges },
      proc{ @empty_range |= 5..10 },
      :before => [],
      :after  => [5..10]
    )
  end

  def test_when_full_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range |= 50..120 },
      :before => [0...360],
      :after  => [0...360]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= 3.8..4.5 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [1.2..1.5, 1.7..1.8, 3.5..7.2]
    )
  end

  def test_when_right_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range |= -10..20 },
      :before => [0...360],
      :after  => [-10...360]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= -2.7..1.2 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [-2.7..1.5, 1.7..1.8, 3.5..7.2]
    )
  end

  def test_when_left_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range |= 330..400 },
      :before => [0...360],
      :after  => [0..400]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= 5.5..7.4 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [1.2..1.5, 1.7..1.8, 3.5..7.4]
    )
  end

  def test_when_not_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range |= -30..400 },
      :before => [0...360],
      :after  => [-30..400]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= -1.5..19.2 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [-1.5..19.2]
    )
  end

  def test_when_smaller_and_not_overlap
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range |= -30..-10 },
      :before => [0...360],
      :after  => [-30..-10, 0...360]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= -1.5..0.3 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [-1.5..0.3, 1.2..1.5, 1.7..1.8, 3.5..7.2]
    )
  end

  def test_when_larger_and_not_overlap
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range |= 370..400 },
      :before => [0...360],
      :after  => [0...360, 370..400]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= 7.3...8.3 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [1.2..1.5, 1.7..1.8, 3.5..7.2, 7.3...8.3]
    )
  end

  def test_multi_range
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= 50..450 },
      :before => [0..100, 200..300, 500..600],
      :after  => [0..450, 500..600]
    )
  end

  def test_other_multi_range
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= MultiRange.new([50..60, 110..120, 180..550, 700]) },
      :before => [0..100, 200..300, 500..600],
      :after  => [0..100, 110..120, 180..600, 700..700]
    )

    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= 7.3...8.3 },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [1.2..1.5, 1.7..1.8, 3.5..7.2, 7.3...8.3]
    )
  end

  def test_other_multi_range_and_not_overlap
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= MultiRange.new([-10..-5, 105..199, 400, 700..900]) },
      :before => [0..100, 200..300, 500..600],
      :after  => [-10..-5, 0..100, 105..300, 400..400, 500..600, 700..900]
    )
  end

  def test_float
    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= MultiRange.new([1.55..1.65, 2.3..3.5]) },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [1.2..1.5, 1.55..1.65, 1.7..1.8, 2.3..7.2]
    )
  end

  def test_float_with_excluded_end_value_being_merged
    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range |= MultiRange.new([2.2...3.5]) },
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after  => [1.2..1.5, 1.7..1.8, 2.2..7.2]
    )
  end

  def test_unbounded_range_without_left_border
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= ..450 },
      :before => [0..100, 200..300, 500..600],
      :after  => [..450, 500..600]
    )
  end

  def test_unbounded_range_without_left_border_excludes_end
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= ...450 },
      :before => [0..100, 200..300, 500..600],
      :after  => [...450, 500..600]
    )
  end

  def test_unbounded_range_without_right_border
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= 250.. },
      :before => [0..100, 200..300, 500..600],
      :after  => [0..100, 200..]
    )
  end

  def test_unbounded_range_without_right_border_excludes_end
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range |= 250... },
      :before => [0..100, 200..300, 500..600],
      :after  => [0..100, 200...]
    )
  end
end
