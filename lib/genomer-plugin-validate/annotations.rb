require 'genomer-plugin-validate'

class GenomerPluginValidate::Annotations < Genomer::Plugin

  VALIDATORS = {
    :validate_for_duplicate_ids => lambda{|i| "Duplicate ID '#{i.id}'" },
    :validate_for_missing_ids   => lambda{|_| "Annotations found with missing ID attribute" },
    :validate_for_identical_locations => lambda do |attns|
      "Identical locations for " << attns.map{|i| "'#{i.id}'"}.sort.join(', ')
    end
  }

  def run
    VALIDATORS.map do |(method,formatter)|
      send(method,annotations).map{|i| formatter.call(i)}
    end.flatten.uniq * "\n" + "\n"
  end

  def organise_by(annotations,&block)
    annotations.inject(Hash.new{|h,k| h[k] = []}) do |hash,attn|
      hash[yield(attn)] <<= attn
      hash
    end
  end

  def validate_for_duplicate_ids(attns)
    organise_by(attns,&:id).values.select{|v| v.length > 1}.flatten
  end

  def validate_for_missing_ids(attns)
    organise_by(attns,&:id)[nil]
  end

  def validate_for_identical_locations(attns)
    organise_by(attns){|i| [i.start,i.end]}.values.select{|v| v.length > 1}
  end

  def validate_for_gff3_attributes(attns)
    []
  end
  
end
