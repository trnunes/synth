module Operations

def load_dbpedia_endpoint
  
  ActiveRDF::ConnectionPool.add_data_source(:type => :sparql,
      :url => "http://dbpedia.org/sparql",
      :engine => :virtuoso,
      :timeout => 10000000)
  end  
  
  def import_dataset
    def log_imp(msg)
      File.open('./log/import_dataset.log', 'a'){|f| f.write(msg << "\n")}
    end
    
    model   = "raw_semantic_wiki"
    format  = 'rdfxml'
    file = params['ontology']['datafile'].path
    new_path = "./public/data/tmp.rdf"
    File.open(new_path, 'w'){|f|f.write(params['ontology']['datafile'].read)}
    
    log_imp(file)
    unless File.exists?("applications/#{model}")
      log_imp("model não existe")
    end    
    log_imp("app exists")
    unless ['rdfxml', 'n3', 'ntriples', 'turtle'].include?(format)
      log_imp("formato não existe")
    end
    app    = Application.active
    log_imp("app: #{app.inspect}")
    app.db.load("#{new_path}", format, nil)
    log_imp("Completei")
    log_imp("Generating Wiki Texts")
    ##
    ###Gemerate wiki pages
    ##
    domain_classes = RDFS::Class.domain_classes.sort{|a,b| a.compact_uri <=> b.compact_uri }
    domain_classes.each{|d|
      
      instances =  ActiveRDF::Query.new.select(:s).where(:s, RDF::type, d).execute
      instances ||= [] 
      
      instances.each{|r|
        if r.swwiki::wikiLabel.to_s.empty?
          label = r.rdfs::label.to_s
          label = r.uri.scan(/[\/\#]([^\/\#]*)/).last.to_s if label.empty?
          log_imp("    LABEL: #{label}")
          r.swwiki::wikiLabel = label
        end
      }
    }
    ##
    ###end
    ##
    
    ##
    ### generate_default_wiki_text
    ## 
    domain_classes = RDFS::Class.domain_classes.sort{|a,b| a.compact_uri <=> b.compact_uri }
    domain_classes.each{|d|
      log_imp("CLASS:  #{d.uri}")
      instances =  ActiveRDF::Query.new.select(:s).where(:s, RDF::type, d).execute
      instances ||= [] 
      log_imp("Instances TO ANALYZE:  #{instances.size}")
      predicate_to_discard = [SWWIKI::content, SWWIKI::wikiText, SWWIKI::wikiLabel, RDFS::label]
      instances.each{|r|
        log_imp("  #{r.uri}")
        if r.swwiki::content.to_s.empty?
          log_imp("    EMPTY TEXT")
          uri = r.uri
          ##
          ### create_default_wiki_text
          ##
            log_imp("    CREATING TEXT")
            r = RDFS::Resource.new(uri)
            wiki_text = ""
            result = ActiveRDF::Query.new.select(:p, :o).where(r, :p, :o).execute
            result.each{|p, o|
              if !predicate_to_discard.include?(p)
                log_imp("PROPERTY: #{p}, OBJECT: #{o}")
                connector = "="
                abbreviated = ActiveRDF::Namespace.abbreviate(p)    
                if !(abbreviated.nil?)
                  abbr_prop_array = abbreviated.split("::")
                  predicate = "#{abbr_prop_array[0].upcase}::#{abbr_prop_array[1]}"
                  object = o.to_s
                  if o.instance_of?(RDFS::Resource)
                    connector = "->"
                    object = o.rdfs::label.first.to_s
                    object =o.uri if object.empty?
                  end
                  if !object.empty?
                    wiki_text += (predicate + connector + object + "\n")
                    log_imp("      PARTIAL WIKI TEXT: #{wiki_text}")
                  end
                end
              end      
            }
            wiki_text = "No content yet." if wiki_text.empty?
            wiki_text
          ##
          ### end
          ##
#          r.swwiki::wikiText = Operations.create_default_wiki_text({:uri=>r.uri})
          r.swwiki::content = wiki_text
          log_imp("    TEXT: #{r.swwiki::wikiText}")
          r.save
        end
      }
    }
    ##
    ### END
    ##
    redirect("test")
  end
  
  def generate_wiki_pages
    def log_wt(msg)
      File.open('./log/import_dataset.log', 'a'){|f| f.write(msg << "\n")}
    end
    domain_classes = RDFS::Class.domain_classes.sort{|a,b| a.compact_uri <=> b.compact_uri }
    domain_classes.each{|d|
      
      instances =  ActiveRDF::Query.new.select(:s).where(:s, RDF::type, d).execute
      instances ||= [] 
      
      instances.each{|r|
        if r.swwiki::wikiLabel.to_s.empty?
          label = r.rdfs::label.to_s
          label = r.uri.scan(/[\/\#]([^\/\#]*)/).last.to_s if label.empty?
          log_wt("    LABEL: #{label}")
          r.swwiki::wikiLabel = label
        end
      }
    }
  end
  
  def generate_default_wiki_text
    def log_wt(msg)
      File.open('./log/import_dataset.log', 'a'){|f| f.write(msg << "\n")}
    end
    domain_classes = RDFS::Class.domain_classes.sort{|a,b| a.compact_uri <=> b.compact_uri }
    domain_classes.each{|d|
      log_wt("CLASS:  #{d.uri}")
      instances =  ActiveRDF::Query.new.select(:s).where(:s, RDF::type, d).execute
      instances ||= [] 
      log_wt("Instances TO ANALYZE:  #{instances.size}")
      instances.each{|r|
        log_wt("  #{r.uri}")
#        if r.swwiki::wikiText.to_s.empty?
          log_wt("    EMPTY TEXT")
          r.swwiki::wikiText = Operations.create_default_wiki_text({:uri=>r.uri})
          log_wt("    TEXT: #{r.swwiki::wikiText}")
          r.save
#        end
      }
    }  
  end
  
  def create_default_wiki_text(uri)
    def log_dt(msg)
      File.open('./log/import_dataset.log', 'a'){|f| f.write(msg << "\n")}
    end
    log_dt("    CREATING TEXT")
    r = RDFS::Resource.new(uri)
    wiki_text = ""
    result = ActiveRDF::Query.new.select(:p, :o).where(r, :p, :o).execute
    result.each{|p, o|
      connector = "="
      abbreviated = ActiveRDF::Namespace.abbreviate(p)    
      if !(abbreviated.nil?)
        abbr_prop_array = abbreviated.split("::")
        predicate = "#{abbr_prop_array[0].upcase}::#{abbr_prop_array[1]}"
        object = o.to_s
        if o.instance_of?(RDFS::Resource)
          connector = "->"
          object = o.rdfs::label.first.to_s
          object =o.uri if object.empty?
        end
        if !object.empty?
          wiki_text += (predicate + connector + object + "\n")
          log_dt("      PARTIAL WIKI TEXT: #{wiki_text}")
        end
      end
            
    }
    wiki_text = "No content yet." if wiki_text.empty?
    wiki_text
  end
  
  def close_dbpedia_endpoint
      ActiveRDF::ConnectionPool.adapters.each{|adapter|
        if(adapter.class == ActiveRDF::SparqlAdapter)
          ActiveRDF::ConnectionPool.close_data_source(adapter)
        end
      }
  end
  
  def abbreviate_uri(uri)
    abbr_prop_uri = ActiveRDF::Namespace.abbreviate(RDF::Resource.new(uri))
    return abbr_prop_uri || uri
  end
  
  def render_query_markup(wiki_page_uri, query_property)
    wikipage = SWWIKI::WikiPage.new(wiki_page_uri)
    abbreviated = ActiveRDF::Namespace.abbreviate(query_property)
    
    if !(abbreviated.nil?)
    	abbr_prop_array = abbreviated.split("::")
    	abbreviated = "#{abbr_prop_array[0].downcase}::#{abbr_prop_array[1]}"
    	query_result = eval("wikipage.#{abbreviated}.to_a")
    end
    
    query_result ||= eval("wikipage.#{RDF::Property.new(query_property).localname}.to_a")
    replacement = ""
    query_result.each{|target_resource|
    
    	if target_resource.instance_of?(RDFS::Resource)
    			tgt_escaped_uri = CGI.escape(target_resource.uri)
    			domain_classes = RDFS::Class.domain_classes.flatten
    
    			tgt_resource_classes = target_resource.classes.select{|klass| domain_classes.include?(klass)}
    			tgt_resource_classes.delete(SWWIKI::WikiPage) if tgt_resource_classes.size > 1
    
    			target_resource_class = tgt_resource_classes.first
    	  	
    			tgt_class_escaped_uri = CGI.escape(target_resource_class.uri)
    			tgt_context = SHDM::Context.find_by.shdm::context_name("ResourcesByClass").execute.first
    			tgt_ctx_escaped_uri = CGI.escape(tgt_context.uri)
    
    			label = target_resource.swwiki::wikiLabel.first
    			aliass ||= label
    			link_params = [label, tgt_ctx_escaped_uri, tgt_escaped_uri, tgt_class_escaped_uri, aliass]
    			if query_result.size == 1
    				replacement = '<a href="/execute/render_target_page?wikiLabel=%s&tgtctx=%s&tgtresource=%s&tgtclass=%s">%s</a>' % link_params
    			else
    				link_params = link_params << "\n"
    				replacement << '* <a href="/execute/render_target_page?wikiLabel=%s&tgtctx=%s&tgtresource=%s&tgtclass=%s">%s</a>%s' % link_params
    			end
    	else
    		if query_result.size > 1
    		replacement << "* #{target_resource} \n"
    		else
    			replacement = "#{target_resource}"
    		end
    	end
    		
    }
    replacement = "\n" << replacement if query_result.size > 1
    
    replacement
  end
  
  def create_swikipage
  def log2(msg)
  	File.open('./log/create_swwikipage.log', 'a'){|f| f.write(msg << "\n")}
  end
  
      label = wikipedia_page_name.dup
   		log2("label #{label}")
      wikipedia_page_name = wikipedia_page_name.gsub(" ", "_")
  
      dbpedia_resource = Operations.import_dbpedia_resource	({:name => wikipedia_page_name})
  		log2("dbpedia_resource_imported")    
      value_prop_hash = Operations.extract_dbpedia_resource_value_property_hash({:dbpedia_resource_uri => dbpedia_resource.uri})
  		log2("value prop hash extracted")    
  
  #    time_begin = init_timer
      raw_wikipedia_text =  Operations.import_raw_wikipedia_page({:wikipedia_page_name => wikipedia_page_name})
  #    end_timer(time_begin, "import raw page")
  		log2("raw page imported")
  		log2(raw_wikipedia_text)    
  #    time_begin = init_timer
      link_markup_list = Operations.extract_link_markup(:text => raw_wikipedia_text)
      log2(link_markup_list.inspect)
  #    end_timer(time_begin, "extract link markup")
      
  #    time_begin = init_timer
      sem_markup_hash = Operations.generate_semantic_markup({:raw_link_markup_list => link_markup_list, :value_prop_hash => value_prop_hash})
  #    end_timer(time_begin, "generate_semantic_markup")
      
  #    time_begin = init_timer
      sem_markup_hash.each{|markup_key, sem_markup|      
        raw_wikipedia_text = raw_wikipedia_text.gsub(markup_key, sem_markup)
      }   
  #    end_timer(time_begin, "replacing orignal markup by semantic ones")
      adapter = ActiveRDF::ConnectionPool.adapters.first
      local_resource = adapter.execute(ActiveRDF::Query.new.select(:p).where(:p, SWWIKI::wikiLabel, label)).flatten.first
      if(local_resource)
        dbpedia_resource = local_resource
      else
        dbpedia_resource = SWWIKI::WikiPage.new(dbpedia_resource.uri)
      end
  #    time_begin = init_timer
      dbpedia_resource.swwiki::wikiLabel = label
  #    end_timer(time_begin, "saving as swwiki page")
      dbpedia_resource.swwiki::content = raw_wikipedia_text
  
     
  #    dbpedia_resource.type<< SWWIKI::WikiPage
       
      dbpedia_resource = dbpedia_resource.save
  
      
      puts "swwiki methods? #{dbpedia_resource.respond_to?("render_semantic_markups")}"
      dbpedia_resource
  end
  
  def import_dbpedia_resource(name)
      name = name.gsub(" ", "_")
      Operations.load_dbpedia_endpoint
      res = RDFS::Resource.new("http://dbpedia.org/resource/#{name}")       
  
  end
  
  def extract_link_markup(text)
  annotMatches = text.to_s.scan(/(\[\[([^\]]*)\]\])/)
  annotMatches
  end
  
  def generate_semantic_markup(raw_link_markup_list, value_prop_hash)
  def log(msg)
  	File.open('./log/generate_semantic_markup', 'a'){|f| f.write(msg << "\n")}
  end
      semantic_markup_hash = {}
      raw_link_markup_list.each{|link_markup|
  			log("markup 0: #{link_markup[0]}, markup 1: #{link_markup[1]}")      
        prop = value_prop_hash[link_markup[1]]
  
       
        prop ||= value_prop_hash["http://dbpedia.org/resource/#{link_markup[1].gsub(" ", "_")}"]
        value = link_markup[0]
        semantic_markup = "[[#{link_markup[1]}]]" if prop.nil?
  
        semantic_markup ||= "[[#{ActiveRDF::Namespace.abbreviate(prop)}->#{link_markup[1]}]]" 
        aliased = value.include?("|")
        has_bending = !value.split("]]")[1].nil?     
        link_alias = ""
        if aliased        
          link_alias = value.split("|")[1].split("]]")[0]
          semantic_markup = semantic_markup.gsub(link_markup[1], link_markup[1].split("|")[0])
        end
        semantic_markup = semantic_markup.gsub("[[", "[[#{link_alias}|") unless link_alias.empty?
        semantic_markup_hash[link_markup[0]] = semantic_markup
  #      log("Original markup: #{link_markup[0]}, semantic_markup: #{semantic_markup}")
      }
      semantic_markup_hash
  end
  
  def import_raw_wikipedia_page(wikipedia_page_name)
  require 'net/http'
  
  Net::HTTP.start("en.wikipedia.org") { |http|
    resp = http.get("/wiki/#{wikipedia_page_name}?action=raw", 'User_Agent' => 'swwiki')
    return resp.body.to_s
  }
  raise "Page not found"
  
  end
  
  def extract_dbpedia_resource_value_property_hash(dbpedia_resource_uri)
  def log(msg)
  	File.open('./log/extract_dbpedia_resource_value_property_hash', 'a'){|f| f.write(msg << "\n")}
  end
  result_set = ActiveRDF::Query.new.select(:p, :o).where(RDFS::Resource.new(dbpedia_resource_uri), :p, :o).execute
  value_property_hash = {}
  result_set.each{|pair|
  #      puts "---------------------"
  #      log "key: #{pair[1]}, value: #{pair[0]}"
  #      if value_property_hash[pair[1].to_s]
  #        value_property_hash[pair[1].to_s] << pair[0]
  #      else
      value_property_hash[pair[1].to_s] = [pair[0]].to_s
  #      end      
  }
  value_property_hash        
  
  end
  
  def get_sameAs(wikipageuri)
  wikipage = RDFS::Resource.new(wikipageuri) 
  ActiveRDF::Query.new.select(:content).where(wikipage, OWL::sameAs, :content).execute.flatten
  end
  
  def generate_rdfa_h1(wikipageuri)
      wikipage = RDFS::Resource.new(wikipageuri)
  
      label = ActiveRDF::Query.new.select(:p).where(wikipage, SWWIKI::wikiLabel, :p).execute.first
      rdfa = Operations.generate_rdfa_property({:prop_uri => SWWIKI::wikiLabel.to_s, :object => label})
      sameResource = Operations.get_sameAs({:wikipageuri => wikipageuri})
      uri = "URI: (<a href=\"#{wikipageuri}\" title=\"Open dbpedia ref in a new tab\" target=\"_blank\">#{wikipageuri}</a>)" if !self.uri.include?("swwiki")
      uri ||= 
      if !sameResource.empty?
        "URI: (<a href=\"#{sameResource.first.uri}\" title=\"Open dbpedia ref in a new tab\" target=\"_blank\">#{sameResource.first.uri}</a>)"
      else
        "URI: (#{wikipageuri})"
      end
      "<h1>#{rdfa}</h1> 
        #{uri}
      "
  end
  
  def find_dbpedia_resource_by_label(label)
  sparql_adapter = Operations.load_dbpedia_endpoint
  puts "LABEL: #{label}"
  dbp_resource_list = sparql_adapter.execute_sparql_query("select ?p where{?p rdfs:label '#{label}'@en}").flatten
  dbp_resource = dbp_resource_list .select{|r| r.uri.to_s == "http://dbpedia.org/resource/#{label}"}.first if dbp_resource_list
  puts "DBP: #{dbp_resource}"
  dbp_resource
  end
  
  def to_html(wikipageuri)
  wikipage = RDFS::Resource.new(wikipageuri)
  arr = Operations.render_semantic_markups({:wikipageuri => wikipageuri})
  text =arr.first
  @rdfa_hash = arr.last
  html = WikiCloth::WikiCloth.new({:data => text.gsub("\.", ". ")}).to_html
  html = html.gsub(' target="_blank"', "")
  html = html.gsub(". ", "\.")
  @rdfa_hash.each_pair{|html_markup, rdfa_markup|
  	html = html.gsub(html_markup, rdfa_markup) unless rdfa_markup.nil?
  }
  
  Operations.generate_rdfa_h1({:wikipageuri => wikipageuri}) << "\n"+html
  end
  
  def generate_rdfa_rel(prop_uri, resource)
  ActiveRDF::Namespace.register(:dbpediaprop, "http://dbpedia.org/property/")
  ActiveRDF::Namespace.register(:dbpedia, "http://dbpedia.org/ontology/")
  ActiveRDF::Namespace.register(:swwiki, "http://www.tecweb.inf.puc-rio.br/ontologies/swwiki#")
  #    puts "prop_uri: #{prop_uri}"
      abbrv_ns = ActiveRDF::Namespace.abbreviate(prop_uri)
      if abbrv_ns
  		splitted_ns = abbrv_ns.split("::")
  		rdf_prop  = "#{splitted_ns[0].downcase}:#{splitted_ns[1]}"
  		'rel="%s" resource="%s"'%[rdf_prop, resource]
      end
  end
  
  def generate_rdfa_property(prop_uri, object)
  ActiveRDF::Namespace.register(:dbpediaprop, "http://dbpedia.org/property/")
  ActiveRDF::Namespace.register(:dbpedia, "http://dbpedia.org/ontology/")
  ActiveRDF::Namespace.register(:swwiki, "http://www.tecweb.inf.puc-rio.br/ontologies/swwiki#")
  
  
  
  #    puts "prop_uri: #{prop_uri}"
      abbrv_ns = ActiveRDF::Namespace.abbreviate(prop_uri)
      if abbrv_ns
  		splitted_ns = abbrv_ns.split("::") 
  		rdf_prop  = "#{splitted_ns[0].downcase}:#{splitted_ns[1]}"
  		'<span property="%s">%s</span>'%[rdf_prop, object]
      end
  end
  
  def clear_see_also
  	 result_list = Application.jena_adapter.execute(ActiveRDF::Query.new.select(
              :see_also).where(self, SWWIKI::wikiSeeAlso, :see_also)).flatten
      result_list.each{|see_also_object|
        Application.jena_adapter.delete(self, SWWIKI::wikiSeeAlso, see_also_object)
      }
  end
  
  def clear_ignored_markups(text)
  text.gsub(/<pre>.*\<\/pre>/, "")
  end
  
  def render_semantic_markups(wikipageuri)
  @rdfa_hash = {}
  ActiveRDF::Namespace.register(:dbpediaprop, "http://dbpedia.org/property/")
  ActiveRDF::Namespace.register(:dbpedia, "http://dbpedia.org/ontology/")
  ActiveRDF::Namespace.register(:swwiki, "http://www.tecweb.inf.puc-rio.br/ontologies/swwiki#")
  wikipage = RDFS::Resource.new(wikipageuri)
  text = wikipage.swwiki::content.first
  markup_hash_list = Operations.extract_semantic_markups({:content => text})
  markup_hash_list.each { |markup_hash|
  
  	aliass = markup_hash[:alias]
  	if(markup_hash[:query])
  		replacement = Operations.render_query_markup({:wiki_page_uri => wikipageuri, :query_property => markup_hash[:propertyName]})
  	else
  	
  		if markup_hash[:objectProperty] and !markup_hash[:value].nil?
  			if markup_hash[:value].class == String
  				replacement = '<a href="/execute/render_target_page?wikiLabel=%s">%s</a>'%[markup_hash[:value], markup_hash[:value]]
  			else
  
  				target_resource = markup_hash[:value]
  				tgt_escaped_uri = CGI.escape(target_resource.uri)
  				domain_classes = RDFS::Class.domain_classes.flatten
  
  				tgt_resource_classes = target_resource.classes.select{|klass| domain_classes.include?(klass)}
  				tgt_resource_classes.delete(SWWIKI::WikiPage) if tgt_resource_classes.size > 1
  
  				target_resource_class = tgt_resource_classes.first
  				
  				tgt_class_escaped_uri = CGI.escape(target_resource_class.uri)
  				tgt_context = SHDM::Context.find_by.shdm::context_name("ResourcesByClass").execute.first
  				tgt_ctx_escaped_uri = CGI.escape(tgt_context.uri)
  
  				label = target_resource.swwiki::wikiLabel.first
  				aliass ||= label
  				link_params = [label, tgt_ctx_escaped_uri, tgt_escaped_uri, tgt_class_escaped_uri, aliass]
  				replacement = '<a href="/execute/render_target_page?wikiLabel=%s&tgtctx=%s&tgtresource=%s&tgtclass=%s">%s</a>' % link_params
  				rdfa = Operations.generate_rdfa_rel({:prop_uri => markup_hash[:propertyName], :resource => "markup_hash[:value]"})
  				link_params.insert(0, rdfa)
  				@rdfa_hash[replacement] = '<a %s href="/execute/render_target_page?wikiLabel=%s&tgtctx=%s&tgtresource=%s&tgtclass=%s">%s</a>' % link_params
  
  			end
  		
  		else
  
  			replacement = aliass
  			value = eval("wikipage.#{RDF::Property.new(markup_hash[:propertyName]).localname}.to_s")
  			replacement ||= value
  			rdfa = Operations.generate_rdfa_property({:prop_uri =>markup_hash[:propertyName] , :object => replacement})			
  			replacement += "propToken"
  			@rdfa_hash[replacement] = rdfa
  		
  		end
    end  
  	text = text.gsub(markup_hash[:match], replacement)
  	text = text.gsub(/<pre>.*#{Regexp.escape(replacement)}.*<\/pre>/){|match| 
  		match.nil? ? "" : match.gsub(replacement, markup_hash[:match])
  	}
  }
  
  [text, @rdfa_hash]
  end
  
  def extract_semantic_markups(content)
  require 'uri'
  
  text = content
  annotations = Array.new()
  text = Operations.clear_ignored_markups({:text => text})
  annotMatches = text.scan(/(\[\[([^\]]*)\]\])/)
  name1_idx = 0
  alias_token_idx = 1
  name2_idx = 2
  predicate_token_idx = 3
  name3_idx = 8
  
  annotMatches.each { |annotMatch|
  	word_with_ifen = annotMatch[1].scan(/-[^>]/).to_s
  	annotMatch[1] = annotMatch[1].gsub(word_with_ifen, "ifen") if word_with_ifen!= ""
  	annotParts = annotMatch[1].scan(/([^\|\-\>\=\?]*)(\|?)([^\->\=\?]*)(((\=)|(\-\>)|(\?\?))?)(.*)/)[0]
  	annotParts = annotParts.map{|annotPart| annotPart.to_s.gsub("ifen", word_with_ifen)} if word_wih_ifen!=""
  	annotation = Hash.new()
  	annotations << annotation    
  
  	if !annotParts[alias_token_idx].to_s.empty?
  		aliased = true
  	end
  	if !annotParts[predicate_token_idx].to_s.empty?
  		predicated = true
  		query_markup = true if annotParts[name3_idx].to_s.empty?
  	end
  
  	annotation[:match] = annotMatch[0]
  	annotation[:propertyName] = "swwiki::wikiSeeAlso"
  	annotation[:objectProperty] = true
  
  
  	if predicated and annotParts[predicate_token_idx] == "="
  			annotation[:objectProperty] = false
  	end
  	
  	if query_markup
  		annotation[:query] = true
  		annotation[:propertyName] = annotParts[name1_idx]
  	else
  		if !aliased and !predicated
  			annotation[:alias] = annotParts[name1_idx]
  			annotation[:value] = annotParts[name1_idx]
  		elsif !aliased and predicated
  			annotation[:alias] = annotParts[name3_idx]
  			annotation[:propertyName] = annotParts[name1_idx]
  			annotation[:value] = annotParts[name3_idx]
  		elsif aliased and !predicated
  			annotation[:alias] = annotParts[name1_idx]
  			annotation[:value] = annotParts[name2_idx]
  		elsif aliased and predicated
  			annotation[:alias] = annotParts[name1_idx]
  			annotation[:propertyName] = annotParts[name2_idx]
  			annotation[:value] = annotParts[name3_idx]
  		end
  	
  		annotation[:value] = annotation[:value].gsub(/([\"\'])*/, "")
  		if annotation[:objectProperty]
  			pageValue = SWWIKI::WikiPage.find_by.swwiki::wikiLabel(annotation[:value]).execute.first
  		  if !pageValue.nil?
  				uri_part = annotation[:value].gsub(" ", "_")
  				encodedPageValue = RDFS::Resource.new(pageValue.uri.gsub(uri_part, URI.encode(uri_part)))			
  				pageValue =  encodedPageValue if (pageValue.classes.size < encodedPageValue.classes.size)			
  				annotation[:value] = pageValue 
  			end
  		end    
  	end
  	
  	if annotation[:propertyName].include? "::"
  		splited_name = annotation[:propertyName].split("::")      
  		prop_uri = ActiveRDF::Namespace.expand(splited_name[0], splited_name[1])
  		annotation[:propertyName] = prop_uri
  	end
  }  
  
  annotations 
  
  end

end