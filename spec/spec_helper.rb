current = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(current, '..', 'lib'), current)

require 'rspec'
require 'scaffolder/test/helpers'
require 'heredoc_unindent'
require 'genomer-plugin-validate'
require 'validator_run_matcher'

RSpec.configure do |config|
  config.mock_with :rr

  include Scaffolder::Test

  def annotation(options = {})
    attrs = options[:attributes] || {}
    attrs[:ID].to_s ||= '1'

    opts = {:start      => options[:start] || 1,
            :end        => options[:end]   || 3,
            :attributes => Hash[attrs.map{|(k,v)| [k.to_s,v]}]}

    Annotation.new(opts).to_gff3_record
  end

  def annotation_with_id(id)
    annotation(:attributes => {:ID => id})
  end

end
