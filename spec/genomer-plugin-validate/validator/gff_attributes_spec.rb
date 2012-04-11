require 'spec_helper'
require 'genomer-plugin-validate/validator/gff3_attributes'

describe GenomerPluginValidate::Validator::Gff3Attributes do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there are valid GFF3 attributes" do
    attrs = %w|ID Name Alias Parent Target Gap Derives_from
               Note Dbxref Ontology_term Is_circular|
    attrs.each do |attr|
      attns = [annotation({:attributes => {attr => 'something'}})]
      it{ should return_no_errors_for attns}
    end
  end

  describe "where there are lower case attribute keys" do
    attns = [annotation({:attributes => {'unknown_term' => 'something'}})]
    it{ should return_no_errors_for attns}
  end

  describe "where there is an unknown capitalised attribute key" do
    attns =  [annotation({:attributes => {'Unknown_term' => 'something','ID' => 1}})]
    errors = ["Illegal GFF3 attribute 'Unknown_term' for '1'"]
    it{ should return_errors_for attns, errors}
  end

end
