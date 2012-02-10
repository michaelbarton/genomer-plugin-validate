require 'genomer-plugin-validate'

class GenomerPluginValidate::Annotations < Genomer::Plugin

  def validate_for_duplicate_ids(annotations)
    ids = annotations.inject(Hash.new{|h,k| h[k] = []}) do |hash,attn|
      hash[attn.id] <<= attn
      hash
    end
    ids.values.select{|v| v.length > 1}.flatten
  end

end
