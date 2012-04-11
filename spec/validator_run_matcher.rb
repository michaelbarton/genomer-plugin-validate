def errors_for(validator,annotations)
  c = validator.new([],{})
  stub(c).annotations{ annotations }
  c.run
end

RSpec::Matchers.define :return_no_errors_for do |annotations|
  match do
    @actual   = errors_for(actual,annotations)
    @expected = []
    actual == expected
  end

  diffable
end

RSpec::Matchers.define :return_errors_for do |annotations,errors|
  match do
    @actual   = errors_for(actual,annotations)
    @expected = errors
    actual == expected
  end

  diffable
end
