require 'spec_helper'
require 'genomer-plugin-validate/validator/gff3_attributes'

describe GenomerPluginValidate::Validator::Gff3Attributes do

  describe "#run" do

    subject do
      c = described_class.new([],{})
      stub(c).annotations{ annotations }
      c.run
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it{ should be_empty }

    end

    attrs = %w|ID Name Alias Parent Target Gap Derives_from Note Dbxref Ontology_term Is_circular |
    attrs.each do |attr|

      describe "where an annotation has the #{attr} attribute" do

        let(:annotations) do
          [annotation({:attributes => {attr => 'something'}})]
        end

        it{should be_empty}

      end

    end

    describe "where there are lower case attribute keys" do

      let(:annotations) do
        [annotation({:attributes => {'lower_case' => 'something'}})]
      end

      it{should be_empty}

    end

    describe "where there is a unknown capitalised attribute key" do

      let(:annotations) do
        [annotation,
         annotation({:attributes => {'Unknown_term' => 'something', 'ID' => '2'}})]
      end

      it{should include "Illegal GFF3 attribute 'Unknown_term' for '2'"}

    end

  end

end
