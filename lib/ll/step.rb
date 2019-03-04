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

  def initialize json_document
    # TODO: Auto convert dasherized to underscore
    data = json_document.to_h.symbolize_keys

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
    @doc_version = data[:doc_version]
    @action_at   = data[:action_at]
  end

  # This is useful to upgrade formats between versions.
  def reformat
    raise NotImplementedError
  end

end
