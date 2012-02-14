Feature: Validating annotation files for identical locations
  In order to submit genome annotations
  A user can use the "annotation" command to detect identical locations
  to ensure that their annotation file contains no errors

  @disable-bundler
  Scenario: Validating an annotations file with two identical locations
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
        contig1	.	gene	1	3	.	+	1	ID=gene2
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
        """
        Identical locations for 'gene1', 'gene2'

        """

  @disable-bundler
  Scenario: Validating an annotations file with two sets of identical locations
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
        contig1	.	gene	1	3	.	+	1	ID=gene2
        contig1	.	gene	4	6	.	+	1	ID=gene3
        contig1	.	gene	4	6	.	+	1	ID=gene4
        contig1	.	gene	7	9	.	+	1	ID=gene5
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
        """
        Identical locations for 'gene1', 'gene2'
        Identical locations for 'gene3', 'gene4'

        """
