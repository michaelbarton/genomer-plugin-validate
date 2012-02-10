current = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(current, '..', 'lib'), current)

require 'rspec'
require 'genomer-plugin-validate'

RSpec.configure do |config|
end
