require 'genomer-plugin-validate'

class GenomerPluginValidate::Annotations < Genomer::Plugin

  VALIDATORS = {
    :validate_for_duplicate_ids => lambda{ |i|
      "WARN: Duplicate ID '#{i.id}' for entry '#{i.seqname} #{i.start}..#{i.end}'" }
  }

  def run
    VALIDATORS.map do |(method,formatter)|
      send(method,annotations).map{|i| formatter.call(i)}
    end.flatten * "\n" + "\n"
  end

  def validate_for_duplicate_ids(annotations)
    ids = annotations.inject(Hash.new{|h,k| h[k] = []}) do |hash,attn|
      hash[attn.id] <<= attn
      hash
    end
    ids.values.select{|v| v.length > 1}.flatten
  end

end
