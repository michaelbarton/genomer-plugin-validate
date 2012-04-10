require 'extensions/string'

module GenomerPluginValidate::Validator

  def self.load
    path = File.join(File.dirname(__FILE__),'..','genomer-plugin-validate','validator','*')
    Dir[path].each do |i|
      require i if i =~ /\.rb/
    end
  end

  def self.validators
    load
    Hash[constants.map do |name|
      [name.to_s.underscore.to_sym, const_get(name)]
    end]
  end

  def annotations_by_attribute(attr)
    annotations.inject(Hash.new{|h,k| h[k] = []}) do |hash,attn|
      attr_value = attn.get_attribute(attr) ? attn.get_attribute(attr).to_s : nil
      hash[attr_value] <<= attn
      hash
    end
  end

end
