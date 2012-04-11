class GenomerPluginValidate::Validator::Gff3Attributes < Genomer::Plugin

  def valid_gff3_attributes
    %w|ID Name Alias Parent Target Gap Derives_from Note
      Dbxref Ontology_term Is_circular|
  end

  def invalid_attributes(attn)
    Hash[attn.attributes].keys.grep(/^[A-Z]/) - valid_gff3_attributes
  end

  def run
    annotations.
      map{|attn| invalid_attributes(attn).map{|attr| [attn.id,attr]} }.
      flatten(1).
      map{|(id,attribute)| "Illegal GFF3 attribute '#{attribute}' for '#{id}'"}
  end
end
