    ##
    ### Import an RDF file with classes and instances
    ### Generates wiki texts from all resource triples
    ### Generates a default navigationa model (One Context and one Landmark for each class)
    ##
    
    def log_imp(msg)
      File.open('./log/import_dataset.log', 'a'){|f| f.write(msg << "\n")}
    end
    #setting the application
    model   = "raw_semantic_wiki"
    #setting the format of the RDF file to be imported
    format  = 'rdfxml'
    file = params['ontology']['datafile'].path
    new_path = "./public/data/tmp.rdf"
    File.open(new_path, 'w'){|f|f.write(params['ontology']['datafile'].read)}
    
    log_imp(file)
    unless File.exists?("applications/#{model}")
      log_imp("model n�o existe")
    end    
    log_imp("app exists")
    unless ['rdfxml', 'n3', 'ntriples', 'turtle'].include?(format)
      log_imp("formato n�o existe")
    end
    app    = Application.active
    # log_imp("app: #{app.inspect}")
    app.db.load("#{new_path}", format, nil)
    
    domain_classes = RDFS::Class.domain_classes.sort{|a,b| a.compact_uri <=> b.compact_uri }
    
    domain_classes.each{|d|
      next if d.uri.include?("WikiPage")
      log_imp("CLASS:  #{d.uri}")
      instances =  ActiveRDF::Query.new.select(:s).where(:s, RDF::type, d).execute
      instances ||= [] 
      # log_imp("Instances TO ANALYZE:  #{instances.size}")
      predicate_to_discard = [SWWIKI::content, SWWIKI::wikiText, SWWIKI::wikiLabel, RDFS::label]
      instances.each{|r|
        # log_imp("  #{r.uri}")
        if r.swwiki::content.to_s.empty?
          # log_imp("    EMPTY TEXT")
          uri = r.uri
          ##
          ### create_default_wiki_text
          ##
            # log_imp("    CREATING TEXT")
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
                else
                  predicate = p.rdfs::label.to_s
                  if predicate.nil? || predicate.to_s.empty?
                    log_imp(" PROPERTY: #{p}")
                    predicate = p.uri.split("/").last
                    predicate = predicate.split("#").last if predicate.include?("#")
                    p.rdfs::label = predicate
                  end
                end
                object = o.to_s
                if o.instance_of?(RDFS::Resource)
                  connector = "->"
                  object = o.rdfs::label.first.to_s
                  object = o.uri.split("/").last.split("#").last.gsub(/[[:upper:]]/){|w| " "+w}.strip if object.empty?
                end
                if !object.empty?
                  wiki_text += ("<br>#{predicate}: [["+predicate + connector + object + "]]\n")
                  # log_imp("      PARTIAL WIKI TEXT: #{wiki_text}")
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
          if r.swwiki::wikiLabel.to_s.empty?
            p.swwiki::wikiLabel = r.uri.split("/").last.split("#").last.gsub(/[[:upper:]]/){|w| " "+w}.strip
          end
          # log_imp("    TEXT: #{r.swwiki::wikiText}")
          r.save
        end
      }
    }