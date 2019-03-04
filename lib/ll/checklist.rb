class LL::Checklist

  attr_reader :name

  def self.load( dir: )
    filepaths = Dir.glob(File.join dir, "checklists/*")
    filepaths.each do | filepath |
      self.new File.read filepath
    end
  end

  def initialize json_document=nil, name: nil
    # TODO: Parse the document
    @name   = name
    @name ||= "Prototypical"
  end

  def parse_document json_document
    raise NotImplementedError
  end

  def to_s
    "Checklist: #{self.name}"
  end

  def to_h
    { name: self.name }
  end

  def to_json
    JSON.dump self.to_hash
  end

end
