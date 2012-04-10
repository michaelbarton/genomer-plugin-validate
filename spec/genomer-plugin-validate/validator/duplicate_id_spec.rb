require 'spec_helper'
require 'genomer-plugin-validate/validator/duplicate_id'

describe GenomerPluginValidate::Validator::DuplicateID do

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

    describe "where there are two annotations with different IDs" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(2)]
      end

      it{ should == []}

    end

    describe "where there are two annotations with the same ID" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(1), annotation_with_id(2)]
      end

      it{ should == ["Duplicate ID '1'"]}

    end

    describe "where there are two sets of annotations with duplicate IDs" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(1), annotation_with_id(1),
         annotation_with_id(2), annotation_with_id(2)]
      end

      it{ should == ["Duplicate ID '1'", "Duplicate ID '2'"]}

    end


  end

end
