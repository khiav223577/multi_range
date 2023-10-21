# frozen_string_literal: true

require 'test_helper'

class RangeIntersectionTest < Minitest::Test
  def setup
    @day_range = MultiRange.new([1..7])
    @overlapping_day_ranges = MultiRange.new([1..4, 3..7])
    @empty_range = MultiRange.new([])
    @multi_range = MultiRange.new([1..3, 5..10])
    @float_range = MultiRange.new([1.2..1.5, 1.7..1.8, 3.5..7.2])
  end

  def test_empty_range_left_hand_side
    assert_before_and_after(
      proc{ @empty_range.ranges },
      proc{ @empty_range &= 5..10 },
      :before => [],
      :after  => []
    )
  end

  def test_empty_range_right_hand_side
    assert_before_and_after(
      proc{ @day_range.ranges },
      proc{ @day_range &= @empty_range },
      :before => [1..7],
      :after  => []
    )
  end

  def test_range_intersection
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range &= [2..6, 8..9] },
      :before => [1..3, 5..10],
      :after  => [2..3, 5..6, 8..9]
    )
  end

  def test_range_includes_end
    assert_before_and_after(
      proc{ @day_range.ranges },
      proc{ @day_range &= [0..6] },
      :before => [1..7],
      :after  => [1..6]
    )
  end

  def test_range_excludes_end
    assert_before_and_after(
      proc{ @day_range.ranges },
      proc{ @day_range &= [0...6] },
      :before => [1..7],
      :after  => [1...6]
    )
  end

  def test_overlapping_ranges_in_left_hand_side
    assert_before_and_after(
      proc{ @overlapping_day_ranges.ranges },
      proc{ @overlapping_day_ranges &= [2..4]},
      :before => [1..4, 3..7],
      :after => [2..4]
    )
  end

  def test_overlapping_ranges_in_right_hand_side
    assert_before_and_after(
      proc{ @day_range.ranges },
      proc{ @day_range &= [2..4, 3..5]},
      :before => [1..7],
      :after => [2..5]
    )
  end

  def test_intersection_floats
    assert_before_and_after(
      proc{ @float_range.ranges },
      proc{ @float_range &= [1.4..4.0]},
      :before => [1.2..1.5, 1.7..1.8, 3.5..7.2],
      :after => [1.4..1.5, 1.7..1.8, 3.5..4.0]
    )
  end

  def test_many_intersection_performance
    assert_performant do
      multi_range_a = MultiRange.new((1..1000).map { |start| (start*10..start*10+5) })
      multi_range_b = MultiRange.new((501..1500).map { |start| (start*10..start*10+5) })

      assert_equal(
        multi_range_a.ranges.last(multi_range_a.ranges.length / 2),
        (multi_range_a & multi_range_b).ranges
      )
    end
  end

  def test_large_intersection_performance
    assert_performant do
      multi_range_a = MultiRange.new([1..10_000_000])
      multi_range_b = MultiRange.new([5_000_001..15_000_000])
      assert_equal(
        [5_000_001..10_000_000],
        (multi_range_a & multi_range_b).ranges
      )
    end
  end

  def test_daily_schedule_intersection_performance
    def day(n)
      (n * 24 * 60 * 60)
    end

    assert_performant do
      (
        MultiRange.new([day(0)..day(30)]) &
        MultiRange.new([day(0)..day(10), day(13)..day(20), day(23)..day(30)]) &
        MultiRange.new([day(0)..day(5), day(7)..day(12), day(14)..day(19), day(21)..day(26), day(28)..day(30)]) &
        MultiRange.new((0..29).map { |i| day(i)..(day(i) + 9 * 60 * 60) })
      ).ranges
    end
  end

  def test_inclusive_range_with_one_element
    multi_range = MultiRange.new([10..10])
    assert_before_and_after(
      proc{ multi_range.ranges },
      proc{ multi_range &= [10..20] },
      :before => [10..10],
      :after  => [10..10]
    )
  end
end
