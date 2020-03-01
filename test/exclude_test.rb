require 'test_helper'

class ExcludeTest < Minitest::Test
  def setup
    @degree_range = MultiRange.new([0...360])
    @empty_range = MultiRange.new([])
    @multi_range = MultiRange.new([0..100, 200..300, 500..600])
  end

  def test_empty_range
    assert_before_and_after(
      proc{ @empty_range.ranges },
      proc{ @empty_range -= 5..10 },
      :before => [],
      :after  => []
    )
  end

  def test_when_full_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range -= 50..120 },
      :before => [0...360],
      :after  => [0...50, 121..359]
    )
  end

  def test_when_right_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range -= -10..20 },
      :before => [0...360],
      :after  => [21..359]
    )
  end

  def test_when_left_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range -= 330..400 },
      :before => [0...360],
      :after  => [0...330]
    )
  end

  def test_when_not_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.ranges },
      proc{ @degree_range -= -30..400 },
      :before => [0...360],
      :after  => []
    )
  end

  def test_multi_range
    assert_before_and_after(
      proc{ @multi_range.ranges },
      proc{ @multi_range -= 50..550 },
      :before => [0..100, 200..300, 500..600],
      :after  => [0...50, 551..600]
    )
  end
end
