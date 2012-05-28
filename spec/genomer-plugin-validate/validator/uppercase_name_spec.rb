require 'spec_helper'
require 'genomer-plugin-validate/validator/uppercase_name'

describe GenomerPluginValidate::Validator::UppercaseName do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there is an annotations with a lowercase name" do
    it{ should return_no_errors_for [annotation(:attributes => {'Name' => 'something'})]}
  end

  describe "where there two annotations with an uppercase name" do
    attns = [annotation(:attributes => {'Name' => 'Something', 'ID' => 1})]
    errors = ["Illegal capitalised Name attribute 'Something' for '1'"]
    it{ should return_errors_for attns, errors}
  end

end
