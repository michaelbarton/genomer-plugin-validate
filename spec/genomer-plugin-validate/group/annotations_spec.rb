require 'spec_helper'
require 'genomer-plugin-validate/group/annotations'

describe GenomerPluginValidate::Group::Annotations do

  its("class.description"){ should == "Validate GFF3 annotations file" }

  its("class.validators"){ should be_instance_of Array }
  its("class.validators"){ should include :duplicate_id }
  its("class.validators"){ should include :missing_id }

end
