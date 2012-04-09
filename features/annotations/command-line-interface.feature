Feature: The valid annotations command line interface
  In order to generate correct genome annotation files
  A user can use the "validator" plugin at the command line
  to validate their annotations

  @disable-bundler
  Scenario: Running with just the 'validate' command
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate`
     Then the exit status should be 0
      And the output should contain:
      """
        annotations    Validate GFF3 annotations file
      """
