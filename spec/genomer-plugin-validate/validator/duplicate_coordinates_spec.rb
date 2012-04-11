require 'spec_helper'
require 'genomer-plugin-validate/validator/duplicate_coordinates'

describe GenomerPluginValidate::Validator::DuplicateCoordinates do

  subject{ described_class }

  describe "where there are no annotations" do
    it{ should return_no_errors_for [] }
  end

  describe "where there are two annotations with different coordinates" do
    attns = [annotation(:start => 1, :end => 3), annotation(:start => 4, :end => 6)]
    it{ should return_no_errors_for attns}
  end

  describe "where there are two annotations with the same coordinates" do
    attns = [annotation(:start => 1, :end => 3, :attributes => {'ID' => '1'}),
             annotation(:start => 1, :end => 3, :attributes => {'ID' => '2'})]
    errors = ["Identical locations for '1', '2'"]
    it{ should return_errors_for attns, errors}
  end

end
