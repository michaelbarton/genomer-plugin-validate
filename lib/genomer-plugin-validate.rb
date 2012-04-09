require "genomer"
require "heredoc_unindent"

class GenomerPluginValidate < Genomer::Plugin

  def run
    if validator = arguments.shift
      require 'genomer-plugin-validate/' + validator
      self.class.const_get(validator.capitalize).new(arguments,flags).run
    else
      help_message
    end
  end

  def help_message
    msg = <<-EOS.unindent
      USAGE: genomer validate <GROUP>
      
      Available validation groups:
    EOS
  end

end
