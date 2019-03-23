class LL::Step

  attr_reader :title,
              :description,
              :action,
              :kind,
              :status,
              :identifier,
              :schema,
              :by,
              :via,
              :action_at,
              :version

  def initialize json_document, document_version:
    # TODO: Auto convert dasherized to underscore
    data = json_document.to_h.symbolize_keys

    @document_version = document_version || LL::VERSION

    @title       = data[:title]
    @description = data[:description]
    @action      = data[:action]
    @kind        = data[:kind]
    @status      = data[:status]
    @identifier  = data[:identifier]
    @schema      = data[:schema]
    @by          = data[:by]
    @via         = data[:via]
    @os          = data[:via]
    @with        = data[:via]
    @action_at   = data[:action_at]
  end

  # This is useful to upgrade formats between versions.
  def reformat
    raise NotImplementedError
  end

  def to_h
    { title: title,
      description: description,
      action: action,
      kind: kind,
      status: status,
      identifier: identifier,
      by: by,
      via: via,
      action_at: action_at }
  end

  def vv_json
    self.to_h.vv_json
  end

end
