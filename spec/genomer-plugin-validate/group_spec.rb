require 'spec_helper'

describe GenomerPluginValidate::Group do

  before do
    @example = GenomerPluginValidate::Group::Example = Class.new
    stub(described_class).require(anything)
  end

  describe "#groups" do

    subject do
      described_class.groups
    end

    its(['example']){should ==  @example}

  end

end
