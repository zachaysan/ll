require "minitest/autorun"
require "ll"

class ChecklistTest < Minitest::Test

  def test_new
    checklist = LL::Checklist.new
    expected_string = "Checklist: Prototypical"
    assert_equal expected_string, checklist.to_s
  end

  def test_current_version_is_supported
    checklist = LL::Checklist.new
    assert_includes checklist.supported_versions,
                    checklist.current_version
  end

  def test_loads_latest_checklist
    fixture = LL::Fixtures.previous_checklist

    former_serialization_identifier = serialization_identifier = \
    "zcte2zaw23xkyvcbpz2vc94i9qbi3xnkgtfxzvld"

    checklist = LL::Checklist.new document: fixture do | checklist |
      refute checklist.document_current?
      expected_version = "0.0.2"
      assert_equal expected_version, checklist.document_version
      assert_equal serialization_identifier,
                   checklist.serialization_identifier
    end

    expected_version = LL::VERSION
    assert_equal expected_version, checklist.document_version

    json = checklist.vv_json
    parsed_json = JSON.parse json


    expected_authority = "github.com/zachaysan/ll"
    expected_kind      = "checklist"
    expected_format    = "json"
    expected_version   = LL::VERSION

    assert_includes parsed_json, "meta"
    meta = parsed_json["meta"]

    assert_equal expected_authority, meta["authority"]
    assert_equal expected_kind,      meta["kind"]
    assert_equal expected_format,    meta["format"]
    assert_equal expected_version,   meta["version"]

    expected_title       = "Gem Tasks"
    expected_description = "Finicky gem build details"
    expected_identifier  = "vux25anby00000000000000000"
    expected_action_at   = "2019-02-21T19:42:06Z"

    assert_equal expected_title,       parsed_json["title"]
    assert_equal expected_description, parsed_json["description"]
    assert_equal expected_identifier,  parsed_json["identifier"]
    assert_equal expected_action_at,   parsed_json["action_at"]

    refute_equal former_serialization_identifier,
                 parsed_json["serialization_identifier"]

    assert_includes parsed_json, "steps"
    steps = parsed_json["steps"]

    expected_count = 3
    assert_equal expected_count, steps.count

    expected_title = "Bump version"
    assert_equal expected_title, steps.first["title"]

    expected_title = "Tweet about upcoming release"
    assert_equal expected_title, steps.second["title"]

    assert_nil steps.third["title"]
  end

end
