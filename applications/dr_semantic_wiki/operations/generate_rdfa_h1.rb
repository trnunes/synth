    def self.log_genrdfa(msg)
      File.open('./log/generate_rdfa_h1.log', 'a'){|f| f.write(msg << "\n")}
    end
    wikipage = RDFS::Resource.new(wikipage_uri)
    label = ActiveRDF::Query.new.select(:p).where(wikipage, SWWIKI::wikiLabel, :p).execute.first
    rdfa = Operations.generate_rdfa_property({:prop_uri=>SWWIKI::wikiLabel.to_s, :object=>label})
    
    result = "<h1>#{rdfa}</h1>"
    result
