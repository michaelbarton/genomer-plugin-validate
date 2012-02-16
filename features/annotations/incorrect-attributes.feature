Feature: Validating annotation files for incorrect attributes
  In order to submit genome annotations
  A user can use the "annotation" command to detect incorrect attributes
  to ensure that their annotation file contains no errors

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
        AAAAATTTTTGGGGGCCCCCAAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	2	.	+	1	ID=gene1
        contig1	.	gene	3	4	.	+	1	Name=gene2;ID=gene2
        contig1	.	gene	5	6	.	+	1	Alias=gene2;ID=gene3
        contig1	.	gene	7	8	.	+	1	Parent=gene1;ID=gene4
        contig1	.	gene	9	10	.	+	1	Target=gene3;ID=gene5
        contig1	.	gene	11	12	.	+	1	Gap=gene4;ID=gene6
        contig1	.	gene	13	14	.	+	1	Derives_from=gene1;ID=gene7
        contig1	.	gene	15	16	.	+	1	Note=something;ID=gene8
        contig1	.	gene	17	18	.	+	1	Dbxref=something;ID=gene9
        contig1	.	gene	19	20	.	+	1	Ontology_term=something;ID=gene10
        contig1	.	gene	21	22	.	+	1	Is_circular=TRUE;ID=gene11
        contig1	.	gene	23	24	.	+	1	Unknown_term=something;ID=gene12
        contig1	.	gene	25	26	.	+	1	unknown_lowercase_term=something;ID=gene13
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "gene13"
      And the output should contain:
        """
        Illegal GFF3 attributes for 'gene12'

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
        AAAAATTTTTGGGGGCCCCCAAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	2	.	+	1	ID=gene1
        contig1	.	gene	3	4	.	+	1	Name=gene2;ID=gene2
        contig1	.	gene	5	6	.	+	1	Alias=gene2;ID=gene3
        contig1	.	gene	7	8	.	+	1	Parent=gene1;ID=gene4
        contig1	.	gene	9	10	.	+	1	Target=gene3;ID=gene5
        contig1	.	gene	11	12	.	+	1	Gap=gene4;ID=gene6
        contig1	.	gene	13	14	.	+	1	Derives_from=gene1;ID=gene7
        contig1	.	gene	15	16	.	+	1	Note=something;ID=gene8
        contig1	.	gene	17	18	.	+	1	Dbxref=something;ID=gene9
        contig1	.	gene	19	20	.	+	1	Ontology_term=something;ID=gene10
        contig1	.	gene	21	22	.	+	1	Is_circular=TRUE;ID=gene11
        contig1	.	gene	23	24	.	+	1	unknown_lowercase_term=something;ID=gene12
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations --validate_for_view`
     Then the exit status should be 0
      And the output should not contain "gene3"
      And the output should contain:
        """
        Illegal view attributes for 'gene12'

        """
