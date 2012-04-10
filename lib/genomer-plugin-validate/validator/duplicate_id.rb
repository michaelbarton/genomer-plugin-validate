class GenomerPluginValidate::Validator::DuplicateID < Genomer::Plugin
  include GenomerPluginValidate::Validator

  def run
    annotations_by_attribute('ID').select{|k,v| v.length > 1}.map do |(id,_)|
      "Duplicate ID '#{id}'"
    end
  end

end
