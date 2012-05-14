Feature: Validating annotation files for incorrect names
  In order to submit genome annotations
  A user can use the "annotation" command to detect uppercase gene names
  to ensure that their annotation file contains none of these

  @disable-bundler
  Scenario: Validating an annotations file with an uppercase name attribute
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
	contig1	.	gene	1	3	.	+	1	Name=Uppercase;ID=1
	contig1	.	gene	4	6	.	+	1	Name=lowercase;ID=2
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
        """
        Illegal capitalised Name attribute 'Uppercase' for '1'
        """
      And the output should not contain:
        """
        Illegal capitalised Name attribute 'lowercase' for '2'
        """
