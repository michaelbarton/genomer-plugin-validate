require "genomer"
require "heredoc_unindent"

class GenomerPluginValidate < Genomer::Plugin
  require 'genomer-plugin-validate/validator'
  require 'genomer-plugin-validate/group'

  def run
    if validator = arguments.shift
      require 'genomer-plugin-validate/' + validator
      self.class.const_get(validator.capitalize).new(arguments,flags).run
    else
      self.class.help_message
    end
  end

  def self.load_validator_groups
    path = File.join(File.dirname(__FILE__),'genomer-plugin-validate','group','*')
    Dir[path].each do |i|
      require i if i =~ /\.rb/
    end
  end

  def self.validator_names_to_classes
    load_validator_groups
    Hash[GenomerPluginValidate::Group.constants.map do |name|
      [name.to_s.downcase,GenomerPluginValidate::Group.const_get(name)]
    end]
  end

  def self.help_message
    msg = <<-EOS.unindent
      USAGE: genomer validate <GROUP>
      
      Available validation groups:
    EOS
    msg << validator_names_to_classes.map do |(k,v)|
      str =  '  '
      str << k.ljust(15)
      str << v.description
    end * "\n"
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

  def self.validator_names(class_name)
      begin
        require 'genomer-plugin-validate/' + class_name
        const_get(class_name.capitalize).const_get(:VALIDATORS)
      rescue LoadError
        raise Genomer::Error, "Unknown validator group: '#{class_name}'"
      end
  end

end
