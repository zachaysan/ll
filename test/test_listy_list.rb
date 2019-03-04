require_relative "test_helper.rb"

class ListyListTest < Minitest::Test

  def test_new
    listy_list = LL::ListyList.new
    assert_equal :boot, listy_list.status
  end

end
