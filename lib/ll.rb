require "pry"
require "vv"

Gem.require_files "ll/*.rb"

module LL

  def default_authority
    "github.com/zachaysan/ll"
  end
  module_function :default_authority

end
