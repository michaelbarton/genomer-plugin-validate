class GenomerPluginValidate::Validator::MissingID < Genomer::Plugin
  include GenomerPluginValidate::Validator

  def run
    missing = annotations_by_attribute('ID').detect{|k,_| k.nil? }
    if missing
      ["Annotations found with missing ID attribute"]
    else
      []
    end
  end

end
