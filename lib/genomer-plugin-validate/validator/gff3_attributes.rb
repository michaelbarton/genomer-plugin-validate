class GenomerPluginValidate::Validator::Gff3Attributes < Genomer::Plugin

  def valid_gff3_attributes
    %w|ID Name Alias Parent Target Gap Derives_from Note
      Dbxref Ontology_term Is_circular|
  end

  def run
    annotations.
      map{|attn| attn.attributes.map{|(k,v)| [k,attn] }}.
      flatten(1).
      select{|(term,_)| term =~ (/^[A-Z]/) }.
      reject{|(term,_)| valid_gff3_attributes.include? term }.
      map{|(term,attn)| "Illegal GFF3 attribute '#{term}' for '#{attn.id}'"}
  end
end
