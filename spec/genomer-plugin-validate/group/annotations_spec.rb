require 'spec_helper'
require 'genomer-plugin-validate/group/annotations'

describe GenomerPluginValidate::Group::Annotations do

  its("class.description"){ should == "Validate GFF3 annotations file" }

end
