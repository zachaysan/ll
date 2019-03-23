require "minitest/autorun"
require "ll"

begin
  require "pry"
rescue LoadError
end

class LL::Fixtures

  def self.read_checklist version
    File.read File.join("test", "fixtures", "checklists", version)
  end

  # Keep these staggered
  def self.checklist
    self.read_checklist "v0.0.2.json"
  end
  def self.previous_checklist
    self.read_checklist "v0.0.2.json"
  end

  def self.latest_checklist
    self.checklist
  end

end
