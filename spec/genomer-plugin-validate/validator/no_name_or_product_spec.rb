require 'spec_helper'
require 'genomer-plugin-validate/validator/no_name_or_product'

describe GenomerPluginValidate::Validator::NoNameOrProduct do

  describe "#run" do

    subject do
      c = described_class.new([],{})
      stub(c).annotations{ annotations }
      c.run
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it{ should be_empty }

    end

    describe "where an annotation does have a Name attribute" do

      let(:annotations) do
        [annotation({:attributes => {'Name' => 'something'}})]
      end

      it{ should be_empty }

    end

    describe "where an annotation does have a product attribute" do

      let(:annotations) do
        [annotation({:attributes => {'product' => 'something'}})]
      end

      it{ should be_empty }

    end

    describe "where an annotation has both a Name and product attribute" do

      let(:annotations) do
        [annotation({:attributes => {'Name' => 'something','product' => 'else'}})]
      end

      it{ should be_empty }

    end

    describe "where an annotation has neither a Name nor a product attribute" do

      let(:annotations) do
        [annotation({:attributes => {'ID' => '1'}})]
      end

      it{ should == ["No 'Name' or 'product' attribute for annotation '1'"] }

    end

    describe "where multiple annotation have neither a Name nor a product attribute" do

      let(:annotations) do
        [annotation({:attributes => {'ID' => '1'}}),
         annotation({:attributes => {'ID' => '2','product' => 'something'}}),
         annotation({:attributes => {'ID' => '3','Name'    => 'something'}}),
         annotation({:attributes => {'ID' => '4'}})]
      end

      it{ should     include "No 'Name' or 'product' attribute for annotation '1'" }
      it{ should_not include "No 'Name' or 'product' attribute for annotation '2'" }
      it{ should_not include "No 'Name' or 'product' attribute for annotation '3'" }
      it{ should     include "No 'Name' or 'product' attribute for annotation '4'" }

    end

  end

end
