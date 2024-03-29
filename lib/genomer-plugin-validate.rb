require "genomer"
require "heredoc_unindent"

class GenomerPluginValidate < Genomer::Plugin
  require 'genomer-plugin-validate/validator'
  require 'genomer-plugin-validate/group'

  def run
    name = arguments.shift
    return self.class.help_message if name.nil?

    group = Group.groups[name]
    raise Genomer::Error, "Unknown validation group '#{name}'" if group.nil?

    group.validators.map{|i| Validator.validators[i]}.map do |v|
      v.new(arguments,flags).run
    end.flatten * "\n"
  end

  def self.help_message
    msg = <<-EOS.unindent
      USAGE: genomer validate <GROUP>
      
      Available validation groups:
    EOS
    msg << Group.groups.map do |(k,v)|
      str =  '  '
      str << k.ljust(15)
      str << v.description
    end * "\n"
  end

end
