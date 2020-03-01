require 'test_helper'

class GemTemplateTest < Minitest::Test # gem_template
  def setup
  end

  def test_that_it_has_a_version_number
    refute_nil ::GemTemplate::VERSION # gem_template
  end
end
