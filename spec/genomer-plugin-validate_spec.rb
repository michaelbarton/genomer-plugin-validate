require 'spec_helper'

describe GenomerPluginValidate do

  describe "#run" do

    after do
      GenomerPluginValidate::Group.send(:remove_const,'Example')
    end

    before do
      @example = GenomerPluginValidate::Group::Example = Class.new
    end

    subject do
      described_class.new([arg].compact,{}).run
    end

    context "passed no arguments" do

      let(:arg) do
        nil
      end

      before do
        def @example.description
          "Some description"
        end
      end

      it "should return the help message" do
        msg = <<-EOS
          USAGE: genomer validate <GROUP>
          
          Available validation groups:
        EOS
        subject.should include msg.unindent
      end

      it "should include the descriptions annotation groups" do
        msg = '  example        Some description'
        subject.should include msg
      end

    end

    context "passed an unknown validation group name" do

      let(:arg) do
        "unknown"
      end

      it "should raise and Genomer::Error" do
        lambda{subject.to_s}.should raise_error Genomer::Error,
          "Unknown validation group 'unknown'"
      end

    end

    context "passed a known validation group name" do

      let(:validator) do
        c = Class.new(Genomer::Plugin)
        any_instance_of(c) do |instance|
          mock(instance).run
        end
        c
      end

      before do
        mock(GenomerPluginValidate::Group).groups{{'example' => @example}}
        mock(@example).validators{ ['example'] }
        mock(GenomerPluginValidate::Validator).validators{{'example' => validator}}
      end

      let(:arg) do
        "example"
      end

      it "should initialize and call #run method for each validator" do
        subject.to_s
      end

    end

  end

end
