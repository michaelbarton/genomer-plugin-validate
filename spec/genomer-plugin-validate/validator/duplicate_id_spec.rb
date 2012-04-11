require 'spec_helper'
require 'genomer-plugin-validate/validator/duplicate_id'

describe GenomerPluginValidate::Validator::DuplicateID do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there are two annotations with different IDs" do
    it{ should return_no_errors_for [annotation_with_id(1), annotation_with_id(2)]}
  end

  describe "where there two annotations with missing IDs" do
    attns = [Annotation.new.to_gff3_record, Annotation.new.to_gff3_record]
    it{ should return_no_errors_for attns}
  end

  describe "where there are two annotations with the same ID" do
    attns  = [annotation_with_id(1), annotation_with_id(1)]
    errors = ["Duplicate ID '1'"]
    it{ should return_errors_for attns, errors}
  end

  describe "where there are two sets of annotations with the same ID" do
    attns  = [annotation_with_id(1), annotation_with_id(1),
              annotation_with_id(2), annotation_with_id(2)]
    errors = ["Duplicate ID '1'", "Duplicate ID '2'"]
    it{ should return_errors_for attns, errors}
  end

end
