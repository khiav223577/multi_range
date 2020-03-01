require 'test_helper'

class MultiRangeTest < Minitest::Test
  def setup
  end

  def test_that_it_has_a_version_number
    refute_nil ::MultiRange::VERSION
  end
end
