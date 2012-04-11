require 'spec_helper'
require 'genomer-plugin-validate/validator/missing_id'

describe GenomerPluginValidate::Validator::MissingID do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there no annotations with missing IDs" do
    it{ should return_no_errors_for [annotation_with_id(1), annotation_with_id(2)] }
  end

  describe "where there an annotation with a missing ID" do
    errors = ["Annotations found with missing ID attribute"]
    it{ should return_errors_for [Annotation.new.to_gff3_record], errors}
  end

  describe "where there are multiple annotations with missing IDs" do
    errors = ["Annotations found with missing ID attribute"]
    attns  = [Annotation.new.to_gff3_record, Annotation.new.to_gff3_record]
    it{ should return_errors_for attns, errors}
  end

end
