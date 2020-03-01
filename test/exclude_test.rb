require 'test_helper'

class ExcludeTest < Minitest::Test
  def setup
    @degree_range = MultiRange.new([0...360])
    @empty_range = MultiRange.new([])
  end

  def test_empty_range
    assert_before_and_after(
      proc{ @empty_range.instance_variable_get(:@ranges) },
      proc{ @empty_range -= 5..10 },
      before: [],
      after: [],
    )
  end

  def test_when_cover_excluded_range
    assert_before_and_after(
      proc{ @degree_range.instance_variable_get(:@ranges) },
      proc{ @degree_range -= 50..120 },
      before: [0...360],
      after: [0...50, 121..359],
    )
  end
end
