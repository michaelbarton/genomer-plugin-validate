require "genomer"
require "heredoc_unindent"

class GenomerPluginValidate < Genomer::Plugin

  def run
    if validator = arguments.shift
      require 'genomer-plugin-validate/' + validator
      self.class.const_get(validator.capitalize).new(arguments,flags).run
    else
      self.class.help_message
    end
  end

  def self.load_validator_groups
    Dir[File.join(File.dirname(__FILE__),'genomer-plugin-validate','*')].each do |i|
      require i if i =~ /\.rb/
    end
  end

  def self.validator_names_to_classes
    load_validator_groups
    Hash[GenomerPluginValidate.constants.map do |name|
      [name.to_s.downcase,GenomerPluginValidate.const_get(name)]
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

end
