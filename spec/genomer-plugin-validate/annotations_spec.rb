require 'spec_helper'
require 'genomer-plugin-validate/annotations'

describe GenomerPluginValidate::Annotations do

  def annotation(options = {})
    Annotation.new(options).to_gff3_record
  end
  
  let(:duplicate) do
    {:attributes => {'ID' => '1'}, :start => 1, :end => 3}
  end

  describe "#run" do

    it "should return an error for duplicate ID annotations" do
      validator = described_class.new([],{})
      stub(validator).annotations do
        [annotation(duplicate), annotation(duplicate.merge({:start => 4, :end => 6}))]
      end
      validator.run.should == <<-EOS.unindent
        Duplicate ID '1'
      EOS
    end
    
    it "should return an error for identical annotation locations" do
      validator = described_class.new([],{})
      stub(validator).annotations do
        [annotation(duplicate), annotation(duplicate.merge(:attributes => {'ID' => 2}))]
      end
      validator.run.should == <<-EOS.unindent
        Identical locations for '1', '2'
      EOS
    end

    it "should return an error for missing ID attributes" do
      validator = described_class.new([],{})
      stub(validator).annotations do
        [annotation(duplicate.merge(:attributes => {}))]
      end
      validator.run.should == <<-EOS.unindent
        Annotations found with missing ID attribute
      EOS
    end

    it "should return an error for invalide uppercase attribute keys" do
      validator = described_class.new([],{})
      stub(validator).annotations do
        [annotation(duplicate.merge(:attributes => {'ID' => 1, 'Unknown_term' => 'something'}))]
      end
      validator.run.should == <<-EOS.unindent
        Illegal GFF3 attributes for '1'
      EOS
    end
  end

  describe "#validate_for_duplicate_ids" do

    subject do
      described_class.new([],{}).validate_for_duplicate_ids(annotations)
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it "should return both annotations" do
        subject.should == annotations
      end

    end

    describe "where all annotations are duplicates" do

      let(:annotations) do
        [annotation(duplicate), annotation(duplicate.merge({:start => 1, :stop => 3}))]
      end

      it "should return all annotations" do
        subject.should == annotations
      end

    end

    describe "where there are two different kinds of duplicates" do

      let(:annotations) do
        dup_2 = {:attributes => {'ID' => '2'}}
        [annotation(duplicate),
         annotation(duplicate.merge({:start => 1, :stop => 3})),
         annotation(dup_2.merge({:start => 4, :stop => 6})),
         annotation(dup_2.merge({:start => 7, :stop => 9}))]
      end

      it "should return all annotations" do
        subject.should == annotations
      end

    end

    describe "where only some annotations are duplicates" do

      let(:annotations) do
        [annotation({:attributes => {'ID' => '2'}}),
         annotation(duplicate),
         annotation(duplicate.merge({:start => 1, :stop => 3}))]
      end

      it "should return only the duplicated annotations" do
        subject.should == annotations[1..2]
      end

    end

  end

  describe "#validate_for_identical_locations" do

    subject do
      described_class.new([],{}).validate_for_identical_locations(annotations)
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it "should return no annotations" do
        subject.should == annotations
      end

    end

    describe "where two annotations have duplicate coordinates" do

      let(:annotations) do
        [annotation(duplicate), annotation(duplicate)]
      end

      it "should return a single array containing the annotations" do
        subject.should == [annotations]
      end

    end

    describe "where there are two different groups of annotations with duplicate locations" do

      before do
        @attn_1 = annotation(duplicate)
        @attn_2 = @attn_1.clone
        @attn_3 = annotation(duplicate.merge({:start => 4, :stop => 6}))
        @attn_4 = @attn_3.clone
      end

      let(:annotations) do
        [@attn_1,@attn_3,@attn_2,@attn_4]
      end

      it "should return all annotations" do
        subject.should == [[@attn_1,@attn_2],[@attn_3,@attn_4]]
      end

    end

    describe "where only some annotations are duplicates" do

      let(:annotations) do
        [annotation(duplicate),
         annotation(duplicate),
         annotation(duplicate.merge({:start => 4, :stop => 6}))]
      end

      it "should return only the duplicated annotations" do
        subject.should == [annotations[0..1]]
      end

    end

  end

  describe "#validate_for_missing_ids" do

    subject do
      described_class.new([],{}).validate_for_missing_ids(annotations)
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it "should return no annotations" do
        subject.should be_empty
      end

    end

    describe "where an annotation does have an id attribute" do

      let(:annotations) do
        [annotation(duplicate)]
      end

      it "should return false" do
        subject.should be_empty
      end

    end

    describe "where an annotation doesn't have an id attribute" do

      let(:annotations) do
        [annotation(duplicate),annotation(duplicate.merge(:attributes => {}))]
      end

      it "should return true" do
        subject.should == annotations[1..1]
      end

    end

  end

  describe "#validate_for_gff3_attributes" do

    subject do
      described_class.new([],{}).validate_for_gff3_attributes(annotations)
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it "should return no annotations" do
        subject.should be_empty
      end

    end

    attrs = %w|ID Name Alias Parent Target Gap Derives_from Note Dbxref Ontology_term Is_circular |
    attrs.each do |attr|

      describe "where an annotation has the #{attr} attribute" do

        let(:annotations) do
          [annotation(duplicate.merge({:attributes => {attr => 'something'}}))]
        end

        it "should return false" do
          subject.should be_empty
        end

      end

    end

    describe "where there are lower case attribute keys" do

      let(:annotations) do
        [annotation(duplicate.merge({:attributes => {'lower_case' => 'something'}}))]
      end

      it "should return no annotations" do
        subject.should == []
      end

    end

    describe "where there is a unknown capitalised attribute keys" do

      let(:annotations) do
        [annotation(duplicate),
         annotation(duplicate.merge({:attributes => {'Unknown_term' => 'something'}}))]
      end

      it "should return the annotation" do
        subject.should == annotations[1..1]
      end

    end
  end

  describe "#validate_for_view_attributes" do

    subject do
      described_class.new([],{}).validate_for_view_attributes(annotations)
    end

    describe "where there are no annotations" do

      let(:annotations) do
        []
      end

      it "should return no annotations" do
        subject.should be_empty
      end

    end

    attrs = %w|product ec_number function|
    attrs.each do |attr|

      describe "where an annotation has the #{attr} attribute" do

        let(:annotations) do
          [annotation(duplicate.merge({:attributes => {attr => 'something'}}))]
        end

        it "should return no annotations" do
          subject.should be_empty
        end

      end

    end

    describe "where there are upper case attribute keys" do

      let(:annotations) do
        [annotation(duplicate.merge({:attributes => {'Lower_case' => 'something'}}))]
      end

      it "should return no annotations" do
        subject.should == []
      end

    end

    describe "where there is a unknown lower case attribute keys" do

      let(:annotations) do
        [annotation(duplicate),
         annotation(duplicate.merge({:attributes => {'unknown_term' => 'something'}}))]
      end

      it "should return the annotation" do
        subject.should == annotations[1..1]
      end

    end
  end

end
