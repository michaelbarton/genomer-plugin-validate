Feature: Validating annotation files for duplicate IDs
  In order to submit genome annotations
  A user can use the "annotation" command to detect duplicate IDs
  to ensure that their annotation file contains no errors

  @disable-bundler
  Scenario: Validating an annotations file with no duplicates
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
        contig1	.	gene	4	6	.	+	1	ID=gene2
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "WARN"

  @disable-bundler
  Scenario: Validating an annotations file two duplicate ID attributes
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
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
        """
        Duplicate ID 'gene1'

        """

  @disable-bundler
  Scenario: Validating an annotations file multiple duplicate ID attributes
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
        contig1	.	gene	7	9	.	+	1	ID=gene2
        contig1	.	gene	10	12	.	+	1	ID=gene2
        contig1	.	gene	13	15	.	+	1	ID=gene3
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "gene3"
      And the output should contain:
        """
        Duplicate ID 'gene1'
        Duplicate ID 'gene2'

        """
