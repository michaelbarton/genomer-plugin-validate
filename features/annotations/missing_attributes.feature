Feature: Validating annotation files for missing attributes
  In order to submit genome annotations
  A user can use the "annotation" command to detect missing ID, Name, product
  to ensure that their annotation file contains no errors

  @disable-bundler
  Scenario: Validating an annotations file with a missing ID attribute
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	3	.	+	1	ID=gene1;Name=something
        contig1	.	gene	4	6	.	+	1	Name=something
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
        """
        Annotations found with missing ID attribute

        """

  @disable-bundler
  Scenario: Validating an annotations file with a missing Name or product attributes
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	2	.	+	1	ID=gene1;Name=something
        contig1	.	gene	3	4	.	+	1	ID=gene2;product=something
        contig1	.	gene	5	6	.	+	1	ID=gene3;product=something;Name=else
        contig1	.	gene	7	8	.	+	1	ID=gene4
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "gene1"
      And the output should not contain "gene2"
      And the output should not contain "gene3"
      And the output should contain:
        """
        No 'Name' or 'product' attribute for annotation 'gene4'
        """

