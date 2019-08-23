require "pry"
require "vv"

module LL
end

Gem.require_files "ll/*.rb"

module LL

  def default_authority
    "github.com/zachaysan/ll"
  end
  module_function :default_authority

end
