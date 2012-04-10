require 'spec_helper'
require 'genomer-plugin-validate/validator/missing_id'

describe GenomerPluginValidate::Validator::MissingID do

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

      it{ should be_nil }

    end

    describe "where there no annotations with missing IDs" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(2)]
      end

      it{ should be_nil}

    end

    describe "where there is a single annotation with a missing IDs" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(1), Annotation.new.to_gff3_record]
      end

      it{ should == "Annotations found with missing ID attribute"}

    end

    describe "where there multiple annotations with missing IDs" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(1),
          Annotation.new.to_gff3_record, Annotation.new.to_gff3_record]
      end

      it{ should == "Annotations found with missing ID attribute"}

    end

  end

end
