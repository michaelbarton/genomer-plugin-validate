Feature: Validating annotation files
  In order to submit genome annotations
  A user can use the "annotation" command
  to ensure that their annotation file contains no errors

  @disable-bundler
  Scenario: Validating an annotations file with duplicate ID attributes
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
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	4	6	.	+	1	ID=gene1
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome`
     Then the exit status should be 1
      And the output should contain:
        """
        WARN: Duplicate ID 'gene1' for entry 'contig1 1..3'
        WARN: Duplicate ID 'gene1' for entry 'contig1 4..6'

        """
