require 'spec_helper'

describe GenomerPluginValidate do

  before do
    @example = GenomerPluginValidate::Group::Example = Class.new
    any_instance_of(described_class) do |u|
      stub(u).require(anything)
    end
  end

  after do
    GenomerPluginValidate::Group.send(:remove_const,'Example')
  end

  describe "#run" do

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

  end

end
