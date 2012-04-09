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

  def self.help_message
    msg = <<-EOS.unindent
      USAGE: genomer validate <GROUP>
      
      Available validation groups:
    EOS
    msg << GenomerPluginValidate::Group.groups.map do |(k,v)|
      str =  '  '
      str << k.ljust(15)
      str << v.description
    end * "\n"
  end

end
