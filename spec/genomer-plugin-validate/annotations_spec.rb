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
      mock(validator).annotations do
        [annotation(duplicate), annotation(duplicate.merge({:start => 4, :end => 6}))]
      end
      validator.run.should == <<-EOS.unindent
        WARN: Duplicate ID '1' for entry 'record 1..3'
        WARN: Duplicate ID '1' for entry 'record 4..6'
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

end
