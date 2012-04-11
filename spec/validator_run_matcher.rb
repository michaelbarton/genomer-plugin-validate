def errors(validator,annotations)
  c = validator.new([],{})
  stub(c).annotations{ annotations }
  c.run
end

RSpec::Matchers.define :return_no_errors_for do |annotations|
  match do |validator|
    errors(validator,annotations).should be_empty
  end
end

RSpec::Matchers.define :return_errors_for do |annotations,errors|
  match do |validator|
    errors(validator,annotations).should == errors
  end
end
