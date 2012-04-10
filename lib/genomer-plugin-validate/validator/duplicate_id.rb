class GenomerPluginValidate::Validator::DuplicateID < Genomer::Plugin
  include GenomerPluginValidate::Validator

  def run
    annotations_by_attribute('ID').
      select{|_,v| v.length > 1}.
      select{|k,_| ! k.nil? }.
      map{|(id,_)| "Duplicate ID '#{id}'" }
  end

end
