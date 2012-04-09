require 'spec_helper'

describe GenomerPluginValidate::Validator do

  before do
    @example = GenomerPluginValidate::Validator::Example = Class.new
    stub(described_class).require(anything)
  end

  after do
    GenomerPluginValidate::Validator.send(:remove_const,'Example')
  end

  describe "#validators" do

    subject do
      described_class.validators
    end

    its(['example']){should ==  @example}

  end

end
