require 'spec_helper'

describe GenomerPluginValidate do

  describe "#run" do

    context "passed no arguments" do

      it "should return the help message" do
        msg = <<-EOS
          USAGE: genomer validate <GROUP>
          
          Available validation groups:
        EOS
        described_class.new([],{}).run.should include msg.unindent
      end

    end

    context "passed the name of a known validation group" do

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

  end
end
