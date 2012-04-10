require 'spec_helper'

describe GenomerPluginValidate::Validator do

  before do
    @example = GenomerPluginValidate::Validator::ExampleValidator = Class.new
    stub(described_class).require(anything)
  end

  after do
    GenomerPluginValidate::Validator.send(:remove_const,'ExampleValidator')
  end

  describe "#validators" do

    subject do
      described_class.validators
    end

    its([:example_validator]){should ==  @example}

  end

  describe "#annotations_by_attribute" do

    subject do
       dummy_class = Class.new
       dummy_class.send(:include, described_class)

       dummy = dummy_class.new
       stub(dummy).annotations{annotations}
       dummy.annotations_by_attribute('ID')
    end

    context "where there are no annotations" do

      let(:annotations) do
        []
      end

      it{ should == {}}

    end

    context "where there is one annotation" do

      let(:annotations) do
        [annotation_with_id(1)]
      end

      its(['1']){ should == annotations }

    end

    context "where there is two annotations with different attributes" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(2)]
      end

      its(['1']){ should == annotations[0..0] }
      its(['2']){ should == annotations[1..1] }

    end

    context "where there is two annotations the same attribute" do

      let(:annotations) do
        [annotation_with_id(1), annotation_with_id(1)]
      end

      its(['1']){ should == annotations }

    end

  end

end
