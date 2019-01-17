class LL::Checklist

  attr_reader :name

  def initialize
    @name = "Prototypical"
  end

  def to_s
    "Checklist: #{self.name}"
  end

end
