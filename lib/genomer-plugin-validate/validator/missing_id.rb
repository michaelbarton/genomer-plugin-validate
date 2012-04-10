class GenomerPluginValidate::Validator::MissingID < Genomer::Plugin
  include GenomerPluginValidate::Validator

  def run
    missing = annotations_by_attribute('ID').detect{|k,_| k.nil? }
    "Annotations found with missing ID attribute" if missing
  end

end
