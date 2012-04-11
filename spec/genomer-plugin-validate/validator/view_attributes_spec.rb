require 'spec_helper'
require 'genomer-plugin-validate/validator/view_attributes'

describe GenomerPluginValidate::Validator::ViewAttributes do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there are capitalized attribute keys" do
    attns = [annotation({:attributes => {'Unknown_term' => 'something'}})]
    it{ should return_no_errors_for attns}
  end

  describe "where there are valid view attributes" do
    attrs = %w|product ec_number function|
    attrs.each do |attr|
      attns = [annotation({:attributes => {attr => 'something'}})]
      it{ should return_no_errors_for attns}
    end
  end

  describe "where there is an unknown lower case attribute key" do
    attns =  [annotation({:attributes => {'unknown_term' => 'something','ID' => 1}})]
    errors = ["Illegal view attribute 'unknown_term' for '1'"]
    it{ should return_errors_for attns, errors}
  end

end
