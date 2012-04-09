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
      [name.to_s.downcase,const_get(name)]
    end]
  end

end
