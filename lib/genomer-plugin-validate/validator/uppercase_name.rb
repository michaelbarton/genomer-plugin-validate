class GenomerPluginValidate::Validator::UppercaseName < Genomer::Plugin
  include GenomerPluginValidate::Validator

  def run
    annotations_by_attribute('Name').
      select{|(name,_)| name =~ /^[A-Z]/}.
      map{|(_,entry)| entry}.
      flatten.
      map{|i| [i.get_attribute('Name'),i.id]}.
      map{|i| "Illegal capitalised Name attribute '%s' for '%s'" % i}
  end

end
