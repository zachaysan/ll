require_relative "test_helper.rb"

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

  def test_version
    refute_nil LL::VERSION

    assert_equal LL::VERSION, LL::Version
    assert_equal LL::VERSION, LL::version

    assert_equal LL::VERSION, LL.VERSION
    assert_equal LL::VERSION, LL.Version
    assert_equal LL::VERSION, LL.version
  end

end
