require 'spec_helper'

describe GenomerPluginValidate do

  before do
    @example = GenomerPluginValidate::Example = Class.new(GenomerPluginValidate)
    any_instance_of(described_class) do |u|
      stub(u).require(anything)
    end
  end

  describe "#run" do

    context "passed no arguments" do

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
        described_class.new([],{}).run.should include msg.unindent
      end

      it "should include the descriptions annotation groups" do
        msg = '  example        Some description'
        described_class.new([],{}).run.should include msg.unindent
      end

    end

    context "passed the name of a known validation group" do

      it "should initialize and call run on the required plugin" do
        any_instance_of(@example){ |u| mock(u).run }
        described_class.new(['example'],{}).run
      end

    end

  end

  describe "#validator_names_to_classes" do

    subject do
      described_class.validator_names_to_classes
    end

    its(['example']){should ==  @example}

  end

end
