class GenomerPluginValidate::Validator::NoNameOrProduct < Genomer::Plugin
  include GenomerPluginValidate::Validator

  def run
    no_product = annotations_by_attribute('product')[nil].map(&:id)
    no_name    = annotations_by_attribute('Name')[nil].map(&:id)

    (no_name & no_product).map do |id|
      "No 'Name' or 'product' attribute for annotation '#{id}'"
    end
  end

end
