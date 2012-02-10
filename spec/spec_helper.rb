current = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(current, '..', 'lib'), current)

require 'rspec'
require 'scaffolder/test/helpers'
require 'genomer-plugin-validate'

RSpec.configure do |config|
  config.mock_with :rr

  include Scaffolder::Test
end
