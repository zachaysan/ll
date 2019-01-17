require "minitest/autorun"
require "ll"

class LLTest < Minitest::Test

  def test_load
    assert_equal Module, LL.class
  end

  def test_vv_present
    assert_equal Module, VV.class
  end

  def test_vv_included
    assert String.vv_included?
  end

end
