class LL::Checklist

  attr_reader :name,
              :authority,
              :title,
              :description,
              :identifier,
              :action_at,
              :steps,
              :document_version,
              :serialization_identifier

  def self.load( dir: )
    filepaths = Dir.glob(File.join dir, "checklists/*")
    filepaths.each do | filepath |
      self.new File.read filepath
    end
  end

  # Maybe abstract the versioning here into VV?
  def initialize document: nil,
                 name: nil,
                 authority: nil
    @name   = name
    @name ||= "Prototypical"

    @authority   = authority
    @authority ||= LL.default_authority

    @document_version = nil

    self.parse_document! document if document

    yield self if block_given?

    self.reformat! unless self.document_current?
  end

  def reformat!
    @document_version = self.current_version

    # Because the same checklist may be serialized multiple times,
    # by different clients it will get tricky tracing problems, so
    # we include an identifier that clients should generate, but never
    # manipulate.
    @serialization_identifier = Random.identifier

    self.steps
  end

  def document_current?
    return nil if @document_version.nil?

    @document_version == self.current_version
  end

  def parse_document! document
    if document.is_a? String
      document = document.parse_json
    elsif document.is_a? Hash
    else
      fail TypeError, "Checklist expects string or hash document"
    end

    document.symbolize_keys!

    attrs = %i[ meta
                title
                description
                identifier
                serialization_identifier
                action_at
                steps ]

    self.set_attrs_via attrs, document: document
  end

  def current_version
    LL::VERSION
  end

  def supported_versions
    %w[ 0.0.2
        0.0.3
        0.0.4
        0.0.5 ]
  end

  def kind
    "checklist"
  end

  def meta= meta
    meta.symbolize_keys!
    meta_authority = meta.fetch :authority
    meta_version   = meta.fetch :version
    meta_kind      = meta.fetch :kind
    meta_format    = meta.fetch :format

    authority_ok = meta_authority == self.authority
    message = "Document authority `#{meta_authority}` unknown."
    fail message unless authority_ok

    format_ok = meta_format == "json"
    message = \
    "Document format `#{meta_format}` not supported, must be `json`."
    fail message unless format_ok

    version_ok = meta_version.one_of?( *supported_versions )
    message = "Document version `#{meta_version}` not supported."
    fail message unless version_ok

    kind_ok = meta_kind == "checklist"
    message = \
    "Document kind `#{meta_kind}` not supported, must be `checklist`."
    fail message unless kind_ok

    @document_version = meta_version
  end

  def steps= steps
    fail "Expecting steps to be an array." unless steps.is_a? Array
    @steps = steps.map do |step|
      fail "Expecting step to be a hash." unless step.is_a? Hash
      LL::Step.new step, document_version: @document_version
    end
  end

  def to_s
    "Checklist: #{self.name}"
  end

  def to_h
    message = \
    "Checklist in indeterminate state. This should never happen."
    fail message unless self.document_current?

    format = "hash"
    meta = { version: self.current_version,
             kind: self.kind,
             authority: self.authority,
             format: format }

    { meta: meta,
      title: self.title,
      description: self.description,
      identifier: self.identifier,
      serialization_identifier: self.serialization_identifier,
      action_at: self.action_at,
      steps: self.steps }
  end

  def vv_json
    format = "json"
    response = self.to_h
    response[:meta][:format] = format
    response.vv_json
  end

end
