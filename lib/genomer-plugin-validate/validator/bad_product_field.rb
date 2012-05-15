class GenomerPluginValidate::Validator::BadProductField < Genomer::Plugin
  include GenomerPluginValidate::Validator

  ERROR = "Bad product field for '%s:' "

  def run
    [
      hypothetical_products,
      domain_related_like_ending_products,
      nterm_products,
      all_caps_products
    ].flatten
  end

  def products_matching(re)
    annotations_by_attribute("product").
      map{|(product,entries)| entries.map{|i| [i.id,product]}}.
      flatten(1).
      map{|(id,product)| [id, re.match(product)]}.
      select{|(_,match)| match}.
      map{|(id,match)| [id,match.to_a.last.downcase]}
  end

  def hypothetical_products
    products_matching(/^([Hh]ypothetical)/).
      map{|i| (ERROR + "start with 'putative' instead of '%s.'") % i}
  end

  def domain_related_like_ending_products
    products_matching(/([Dd]omain|[Rr]elated|[Ll]ike).?$/).
      map{|i| (ERROR + "products ending with '%s' are not allowed.") % i}
  end

  def nterm_products
    products_matching(/([Nn][-\s][Tt]ermi?n?a?l?)/).
      map{|i| (ERROR + "products containing '%s' are not allowed.") % i}
  end

  def all_caps_products
    products_matching(/^([A-Z\s-]+)$/).
      map(&:first).
      map{|i| (ERROR + "all caps product fields are not allowed.") % i}
  end

end
