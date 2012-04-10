class GenomerPluginValidate::Group::Annotations

  def self.description
    "Validate GFF3 annotations file"
  end

  def self.validators
    [
      :duplicate_id,
      :missing_id,
      :no_name_or_product
    ]
  end

end
