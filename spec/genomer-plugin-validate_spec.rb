require 'spec_helper'

describe GenomerPluginValidate do

  describe "#run" do

    before do
      @example = GenomerPluginValidate::Example = Class.new(GenomerPluginValidate)
      any_instance_of(described_class) do |u|
        mock(u).require(anything)
      end
    end

    it "should initialize and call run on the required plugin" do
      any_instance_of(@example){ |u| mock(u).run }
      described_class.new(['example'],{}).run
    end

  end

  describe "#validator_classes_for_names" do

    subject do
      described_class.validator_classes_for_names names
    end

    context "passed an empty array" do

      let(:names) do
        []
      end

      it {should be_empty}

    end

    context "passed the name of a known validator" do

      before do
        @example = GenomerPluginValidate::Validator::Example = Class.new
      end

      let(:names) do
        [:example]
      end

      it {should == [@example]}

    end

    context "passed the name of an unknown validator" do

      let(:names) do
        [:unknown]
      end

      it "should raise a Genomer::Error" do
        lambda{ subject.to_s }.should raise_error Genomer::Error,
          "Unknown validator: 'Unknown'"
      end

    end

  end

  describe "#validator_names" do

    subject do
      described_class.validator_names validator_name
    end

    context "passed the name of an existing class" do

      before do
        mock(described_class).require('genomer-plugin-validate/example')
        class GenomerPluginValidate::Example
          VALIDATORS = [:something]
        end
      end

      let(:validator_name) do
        'example'
      end

      it {should == [:something]}

    end

    context "passed the name of an unknown file" do

      let(:validator_name) do
        'unknown'
      end

      it "should raise a Genomer::Error" do
        lambda{ subject.to_s }.should raise_error Genomer::Error,
          "Unknown validator group: 'unknown'"
      end

    end

  end

end
