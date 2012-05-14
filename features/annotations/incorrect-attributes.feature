Feature: Validating annotation files for incorrect attributes
  In order to submit genome annotations
  A user can use the "annotation" command to detect incorrect attributes
  to ensure that their annotation file contains no errors

  Scenario Outline: Validating an annotations file with known GFF attributes
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
        AAAAATTTTTGGGGGCCCCCAAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	3	4	.	+	1	ID=gene1;Name=gene1;<attribute>=abc
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "gene1"
    Examples:
       | attribute     |
       | Alias         |
       | Parent        |
       | Target        |
       | Gap           |
       | Derives_from  |
       | Note          |
       | Dbxref        |
       | Ontology_term |
       | Is_circular   |

  Scenario Outline: Validating an annotations file with known genomer-plugin-view attributes
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
        AAAAATTTTTGGGGGCCCCCAAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	3	4	.	+	1	ID=gene1;Name=gene1;<attribute>=abc
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "gene1"
    Examples:
        | attribute    |
        | product      |
        | function     |
        | ec_number    |
        | feature_type |

  Scenario: Validating an annotations file with unknown GFF3 attributes
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
        AAAAATTTTTGGGGGCCCCCAAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	3	4	.	+	1	ID=gene1;Name=abc;Unknown_term=something
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
        """
        Illegal GFF3 attribute 'Unknown_term' for 'gene1'
        """

  Scenario: Validating an annotations file with unknown genomer-plugin-view attributes
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
        AAAAATTTTTGGGGGCCCCCAAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	3	4	.	+	1	ID=gene1;Name=abc;unknown_lowercase_term=something
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations --validate_for_view`
     Then the exit status should be 0
      And the output should contain:
        """
        Illegal view attribute 'unknown_lowercase_term' for 'gene1'
        """
