class GenomerPluginValidate::Group::Annotations

  def self.description
    "Validate GFF3 annotations file"
  end

  def self.validators
    [
      :duplicate_id,
      :missing_id,
      :no_name_or_product,
      :gff3_attributes,
      :view_attributes,
      :duplicate_coordinates
    ]
  end

end
