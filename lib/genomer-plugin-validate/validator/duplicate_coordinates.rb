class GenomerPluginValidate::Validator::DuplicateCoordinates < Genomer::Plugin

  def run
    annotations.
      group_by{|attn| [attn.start, attn.end].sort }.
      select{|_,v| v.length > 1}.
      map{|(coords,attns)| attns.map(&:id).sort }.
      map{|attns| attns.map{|attns| "'#{attns}'"}.join(', ') }.
      map{|attns| "Identical locations for #{attns}" }
  end

end
