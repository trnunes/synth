		def self.log_render(msg)
			File.open("./log/render_semantic_markups.log", 'a'){|f|f.write(msg << "\n")}
		end
	# the RDFa hash is necessary because of a trick of the wikicloth engine
    @rdfa_hash = {}
    
    # registering dbpedia and local namespaces	
    ActiveRDF::Namespace.register(:dbpediaprop, "http://dbpedia.org/property/")
    ActiveRDF::Namespace.register(:dbpedia, "http://dbpedia.org/ontology/")
    ActiveRDF::Namespace.register(:swwiki, "http://www.tecweb.inf.puc-rio.br/ontologies/swwiki#")	
    wikipage = RDFS::Resource.new(wikipage_uri)
	
	# retrieving the wiki content
    text = wikipage.swwiki::content.first
	
	# extracting markup hash list form the content
    markup_hash_list = Operations.extract_semantic_markups({:content=> text})
    markup_hash_list.each { |markup_hash|
			
      aliass = markup_hash[:alias]

      if(markup_hash[:query])
	    # getting the wiki text for the values of the query property
				
        replacement = Operations.render_query_markup({:wiki_page_uri=>wikipage_uri, :query_property=>markup_hash[:propertyName]})
				
      else      
        if markup_hash[:objectProperty] and !markup_hash[:value].nil?

					if markup_hash[:value].class == String
						replacement = '<a href="/execute/render_target_page?wikiLabel=%s">%s</a>'%[markup_hash[:value], markup_hash[:value]]
					else
						# getting the resource that is the value of the markup
						target_resource = markup_hash[:value]
						label = target_resource.swwiki::wikiLabel.first
						aliass ||= label
						
						# building the html for the markup
						replacement = Operations.get_target_page_url({:target_page_uri=>target_resource.uri, :link_name=>aliass})			
						
						#generating the rdfa for the object property
						rdfa = Operations.generate_rdfa_rel({:prop_uri=>markup_hash[:propertyName], :resource=>markup_hash[:value]})
						@rdfa_hash[replacement] = replacement.gsub("<a", "<a #{rdfa}")
					end
        else #if is a datatype property
		  
          replacement = aliass
          value = eval("wikipage.#{RDF::Property.new(markup_hash[:propertyName]).localname}.to_s")
          replacement ||= value
          rdfa = Operations.generate_rdfa_property({:prop_uri=>markup_hash[:propertyName] , :object=>replacement})		  
		  
		 			# a value of a datatype property is a literal, so is necessary to put 
				  # a token to identify for the RDFa substitution
          replacement += "propToken"
          @rdfa_hash[replacement] = rdfa        
        end
      end
			
			
			
      text = text.gsub(markup_hash[:match], replacement)
			
			
      text = text.gsub(/<pre>.*#{Regexp.escape(replacement)}.*<\/pre>/){|match| 
        match.nil? ? "" : match.gsub(replacement, markup_hash[:match])
      }
      text.gsub!("propToken", "")
			
    }
    
    [text, @rdfa_hash]
