require_relative "test_helper.rb"

class StepTest < Minitest::Test

  def test_new_step
    step_input = \
    { "title": "Bump version",
      "description": nil,
      "action": "create",
      "kind": "simple",
      "status": "boot",
      "identifier": "vux25anby10000000000000000",
      "by": "zachaysan@gmail.com",
      "via": "zach@vux",
      "os": "Ubuntu 18.04.2 LTS",
      "with": "ll-v0.0.2",
      "doc_version": "0.0.2",
      "action_at": "2019-02-21T19:41:06Z"}.to_json

    step = LL::Step.new step_input
    expected_status = "boot"
    assert_equal expected_status, step.status
  end

end
