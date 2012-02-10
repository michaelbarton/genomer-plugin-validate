require "genomer"

class GenomerPluginValidate < Genomer::Plugin

  def run
    validator = arguments.shift
    require 'genomer-plugin-validate/' + validator
    self.class.const_get(validator.capitalize).new(arguments,flags).run
  end

end
