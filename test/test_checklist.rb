require "minitest/autorun"
require "ll"

class ChecklistTest < Minitest::Test

  def test_new
    checklist = LL::Checklist.new
    expected_string = "Checklist: Prototypical"
    assert_equal expected_string, checklist.to_s
  end

end
