require 'genomer-plugin-validate'

class GenomerPluginValidate::Annotations < Genomer::Plugin

  GFF3_KEYS = %w|ID Name Alias Parent Target Gap Derives_from Note Dbxref
      Ontology_term Is_circular|

  VIEW_KEYS = %w|product function ec_number|

  VALIDATORS = {
    :validate_for_duplicate_ids   => lambda{|i| "Duplicate ID '#{i.id}'" },
    :validate_for_gff3_attributes => lambda{|i| "Illegal GFF3 attributes for '#{i.id}'" },
    :validate_for_view_attributes => lambda{|i| "Illegal view attributes for '#{i.id}'" },
    :validate_for_missing_ids     => lambda{|_| "Annotations found with missing ID attribute" },
    :validate_for_missing_name_or_product => lambda do |i|
        "No 'Name' or 'product' field for annotation '#{i.id}'"
    end,
    :validate_for_identical_locations => lambda do |attns|
      "Identical locations for " << attns.map{|i| "'#{i.id}'"}.sort.join(', ')
    end
  }

  def self.description
    "Validation GFF3 annotations file"
  end

  def run
    VALIDATORS.map do |(method,formatter)|
      next if method == :validate_for_view_attributes && flags[:validate_for_view].nil?
      send(method,annotations).map{|i| formatter.call(i)}
    end.flatten.compact.uniq * "\n" + "\n"
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
    attns.select do |attn|
      ! Hash[attn.attributes].keys.grep(/^[A-Z]/).all?{|k| GFF3_KEYS.include? k }
    end
  end

  def validate_for_view_attributes(attns)
    attns.select do |attn|
      ! Hash[attn.attributes].keys.grep(/^[a-z]/).all?{|k| VIEW_KEYS.include? k }
    end
  end

  def validate_for_missing_name_or_product(attns)
    filter = lambda{|i| i.attributes.select{|(k,v)| k =~ /Name|product/ }  }
    organise_by(attns,&filter).select{|(k,v)| k.nil? }.values.flatten
  end

end
