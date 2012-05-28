Feature: Validating annotation files for bad product fields
  In order to submit genome annotations
  A user can use the "annotation" command to find bad product fields
  to ensure that their annotation file contains valid product information

  Scenario Outline: Validating an annotations file with bad product fields
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
        AAAAA
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	3	4	.	+	1	ID=gene1;product=<product>
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should contain:
     """
     Bad product field for 'gene1:' <correction>
     """
    Examples:
       | product              | correction                                        |
       | hypothetical thing   | start with 'putative' instead of 'hypothetical.'  |
       | Hypothetical thing   | start with 'putative' instead of 'hypothetical.'  |
       | something like       | products ending with 'like' are not allowed.      |
       | something like.      | products ending with 'like' are not allowed.      |
       | something-like       | products ending with 'like' are not allowed.      |
       | something Like       | products ending with 'like' are not allowed.      |
       | something domain     | products ending with 'domain' are not allowed.    |
       | something-domain     | products ending with 'domain' are not allowed.    |
       | something domain.    | products ending with 'domain' are not allowed.    |
       | something Domain     | products ending with 'domain' are not allowed.    |
       | something-related    | products ending with 'related' are not allowed.   |
       | something related    | products ending with 'related' are not allowed.   |
       | something related.   | products ending with 'related' are not allowed.   |
       | something Related    | products ending with 'related' are not allowed.   |
       | something n-term     | 'N-terminal' or variations are not allowed.       |
       | something N-term     | 'N-terminal' or variations are not allowed.       | 
       | something N-terminal | 'N-terminal' or variations are not allowed.       |
       | something n-terminal | 'N-terminal' or variations are not allowed.       |
       | SOMETHING            | all caps product fields are not allowed.          |
       | SOMETHING PROTEIN    | all caps product fields are not allowed.          |
       | SOMETHING-PROTEIN    | all caps product fields are not allowed.          |

  Scenario Outline: Validating an annotations file with acceptable product fields
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
        AAAAA
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	3	4	.	+	1	ID=gene1;product=<product>
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate annotations`
     Then the exit status should be 0
      And the output should not contain "gene1"
    Examples:
       | product                   |
       | hypothetical protein      |
       | hypothetical protein.     |
       | Hypothetical protein      |
       | Hypothetical protein.     |
       | transcription termination |
