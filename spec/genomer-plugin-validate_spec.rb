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

end
