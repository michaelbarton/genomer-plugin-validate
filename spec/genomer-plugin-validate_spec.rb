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

  end

end
