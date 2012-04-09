require "genomer"

class GenomerPluginValidate < Genomer::Plugin
  require 'genomer-plugin-validate/validator'

  def run
    validator = arguments.shift
    require 'genomer-plugin-validate/' + validator
    self.class.const_get(validator.capitalize).new(arguments,flags).run
  end

  def self.validator_classes_for_names(names)
    names.map(&:capitalize).map do |name|
      begin
        GenomerPluginValidate::Validator.const_get name
      rescue NameError
        raise Genomer::Error, "Unknown validator: '#{name}'"
      end
    end
  end

end
