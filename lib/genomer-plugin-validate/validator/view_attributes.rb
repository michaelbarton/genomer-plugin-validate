class GenomerPluginValidate::Validator::ViewAttributes < Genomer::Plugin

  def valid_view_attributes
    %w|product ec_number function|
  end

  def run
    annotations.
      map{|attn| attn.attributes.map{|(k,v)| [k,attn] }}.
      flatten(1).
      select{|(term,_)| term =~ (/^[a-z]/) }.
      reject{|(term,_)| valid_view_attributes.include? term }.
      map{|(term,attn)| "Illegal view attribute '#{term}' for '#{attn.id}'"}
  end

end
