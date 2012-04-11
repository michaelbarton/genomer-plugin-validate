require 'spec_helper'
require 'genomer-plugin-validate/validator/no_name_or_product'

describe GenomerPluginValidate::Validator::NoNameOrProduct do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where an annotation has a Name attribute" do
    attns = [annotation({:attributes => {'Name' => 'something'}})]
    it{ should return_no_errors_for attns}
  end

  describe "where an annotation has a Product attribute" do
    attns = [annotation({:attributes => {'product' => 'something'}})]
    it{ should return_no_errors_for attns}
  end

  describe "where an annotation has neither a Name nor a product attribute" do
    attns  = [annotation({:attributes => {'ID' => '1'}})]
    errors = ["No 'Name' or 'product' attribute for annotation '1'"]
    it{ should return_errors_for attns, errors}
  end

end
