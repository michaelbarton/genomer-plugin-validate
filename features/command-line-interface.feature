Feature: The validator command line interface
  In order to generate correct genomer builds
  A user can use the "validator" plugin at the command line
  to validate their genome build

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
        USAGE: genomer validate <GROUP>

        Available validation groups:
        """

  @disable-bundler
  Scenario: Running with an unknown validation group
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-validate', :path => '../../../'
        """
     When I run `genomer validate unknown`
     Then the exit status should be 1
      And the output should contain:
        """
        Error. Unknown validation group 'unknown'
        """
