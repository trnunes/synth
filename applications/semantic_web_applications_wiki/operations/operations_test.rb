require 'test_helper'
require 'test/unit/semantic_wiki_unit_test.rb'
require 'WikiCloth'
#
# * Name: OperationsTest
# * Author: Thiago R. Nunes
# * Description: test suit for Operations module operations
# * Version 1.0
#
class OperationsTest < SemanticWikiUnitTest
  
 #
# * Name: to_html
# * Description: Generates an html version of the page content. This method is responsible to 
#                call the appropriate methods to handle the semantic markups and then delegate to
#                the WikiCloth engine to parse the non semantic Wikipedia markups.
# * Parameters:
#     ** wikipage_uri: the uri of the wikipage
# * Returns:
#    ** A string that is the html version of the content of the page
#
  def self.to_html(wikipage_uri)
    wikipage = RDFS::Resource.new(wikipage_uri)
    
    #rendering all semantic markups
    arr = render_semantic_markups(wikipage_uri)
    text =arr.first
    @rdfa_hash = arr.last
    
    #this is necessary due to an issue of the Wikicloth engine that do not 
    #handle the ".*" string pattern    
    html = WikiCloth::WikiCloth.new({:data => text.gsub("\.", ". ")}).to_html
    
    #this is necessary because another issue of the Wikicloth that inserts an space
    #on the pattern 'target="_blank"' causing an html error
    html = html.gsub(' target="_blank"', "")
    html = html.gsub(". ", "\.")
    
    #generation of RDFa
    @rdfa_hash.each_pair{|html_markup, rdfa_markup|
      html = html.gsub(html_markup, rdfa_markup) unless rdfa_markup.nil?
    }
    
    #generation of first header
    generate_rdfa_h1(wikipage_uri) << "\n"+html
   
 end
#
# * Name: render_semantic_markups
# * Description: This operation renders all semantic markups in HTML.
#                  The semantic markups rendered are:
#                   1- datatype property markup: [[FOAF::age=25]]
#                    2- semantic link markup: [[FOAF::knows->John]]
#                    3- query markup: [[FOAF::knows??]]
# * Parameters:
#    ** wikipage_uri: the URI of the wikipage to be rendered
# * Returns:
#    ** A string that is the HTML parsed from the wiki content of the page.
#
  def self.render_semantic_markups(wikipage_uri)
    
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
    markup_hash_list = extract_semantic_markups(text)
    markup_hash_list.each { |markup_hash|
    
      aliass = markup_hash[:alias]

      if(markup_hash[:query])
	    # getting the wiki text for the values of the query property
        replacement = render_query_markup(wikipage_uri, markup_hash[:propertyName])
      else      
        if markup_hash[:objectProperty] and !markup_hash[:value].nil?
					# getting the resource that is the value of the markup
          target_resource = markup_hash[:value]			    
          label = target_resource.swwiki::wikiLabel.first
          aliass ||= label
					# building the html for the markup
          replacement = get_target_page_url(target_resource.uri, aliass)			
					#generating the rdfa for the object property
          rdfa = generate_rdfa_rel(markup_hash[:propertyName], markup_hash[:value])
          @rdfa_hash[replacement] = replacement.gsub("<a", "<a #{rdfa}")
        else #if is a datatype property
		  
          replacement = aliass
          value = eval("wikipage.#{RDF::Property.new(markup_hash[:propertyName]).localname}.to_s")
          replacement ||= value
          rdfa = generate_rdfa_property(markup_hash[:propertyName] , replacement)		  
		  
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
    }
    
    [text, @rdfa_hash]
  end
  
#
# * Name: get_target_page_url
# * Description: Generates the HTML link for a target wiki page
# * Parameters:
#     ** target_page_uri: the URI of the wikipage to link up
#     ** link_name: the name of the link
# * Returns:
#    ** A String that is the html href for the target page
#
	def self.get_target_page_url(target_page_uri, link_name)
   
		target_resource = SWWIKI::WikiPage.new(target_page_uri)
	  tgt_escaped_uri = CGI.escape(target_resource.uri)
		#extracting the first domain class different of SWWIKI::WikiPage		
		domain_classes = RDFS::Class.domain_classes.flatten    
		tgt_resource_classes = target_resource.classes.select{|klass| domain_classes.include?(klass)}
		tgt_resource_classes.delete(SWWIKI::WikiPage) if tgt_resource_classes.size > 1    
		target_resource_class = tgt_resource_classes.first
		tgt_class_escaped_uri = CGI.escape(target_resource_class.uri)
		# when ported to synth,this line should be replaced by: SHDM::Context.find_by.shdm::context_name("ResourcesByClass").execute.first
		tgt_context = RDFS::Resource.new("http://ctx_uri")
		tgt_ctx_escaped_uri = CGI.escape(tgt_context.uri)

		label = target_resource.swwiki::wikiLabel.first

		link_params = [label, tgt_ctx_escaped_uri, tgt_escaped_uri, tgt_class_escaped_uri, link_name]
		# building the html for the markup
		replacement = '<a href="/execute/render_target_page?wikiLabel=%s&tgtctx=%s&tgtresource=%s&tgtclass=%s">%s</a>' % link_params
	end 
#
# * Name: render_query_markup
# * Description: Generates the HTML for a property present in a query markup. 
#                 If the property has multiple values, a list of values is generated.
#                If the property is an object property, a link to the object wikipage is generated.
# * Parameters:
#     ** wiki_page_uri: the URI of the wikipage to be queried
#     ** query_property: the URI of the query property 
# * Returns:
#    ** A String that is the representation of the objects ?o of the triple <wiki_page_uri, query_property, ?o>
#
  def self.render_query_markup(wiki_page_uri, query_property)    
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

          label = target_resource.swwiki::wikiLabel.first.to_s

          if query_result.size == 1
            replacement = get_target_page_url(target_resource.uri, label)
          else
            link_params = link_params << "\n"
            replacement << '* %s' % [get_target_page_url(target_resource.uri, label)]
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
  
#
# * Name: extract_semantic_markups
# * Description: This operation extracts all semantic markups and its parts from the wiki content. Each
#                  extracted markup is represented by a dictionary.  
# * Parameters:
#    ** content
# * Returns:
#     ** A list of markup dictionaries where each dictionary represents the markup parts with
#        the following structure:
#                markup[:match]: this is the key of the whole semantic markup
#             markup[:query]: a boolean that indicates if it's a query markup or not
#             markup[:alias]: this is the key of the alias if it's present in the markup 
#             markup[:propertyName]: the key of the property URI
#             markup[:objectProperty]: the key of a boolean that indicates if it's an object property or not.
#             markup[:value]: the key of the object in the markup
#
  def self.extract_semantic_markups(content) 
    require 'uri'  
    text = content
    annotations = Array.new()
    text = clear_ignored_markups(text)
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
      annotParts = annotParts.map{|annotPart| annotPart.to_s.gsub("ifen", word_with_ifen)} if word_with_ifen!=""
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
  
#
# * Name: save_content
# * Description: This operation updates the RDF graph that represents the semantics of the wikipage content.
# * Parameters:
#    ** wikipage_uri: the URI of the wikipage to be updated
#    ** content: the wiki content
#
  def self.save_content(wikipage_uri, content)
    require 'uri'    
    adapter = ActiveRDF::ConnectionPool.adapters.first
    page = SWWIKI::WikiPage.new(wikipage_uri)
    
    markup_hash = extract_semantic_markups(content)
    markup_hash.each { |annotation|
      if(!annotation[:query])
        if ( annotation[:propertyName] =~ URI::regexp).nil?
          domain_property = RDF::Property.find_by.rdfs::label(annotation[:propertyName]).execute.first
		  # if property does not exists create
          if(!domain_property)
            prop_uri = ActiveRDF::Namespace.expand(SWWIKI.prefix, annotation[:propertyName])
            domain_property = RDF::Property.new(prop_uri)
            domain_property.rdfs::label = annotation[:propertyName]
          end   
          domain_property.save
        end
    
        domain_property ||= RDF::Property.new(annotation[:propertyName])
        if annotation[:objectProperty]
          prop_without_ns = content.scan(/\[\[[^::]*#{annotation[:propertyName]}--*/)
          if annotation[:value].class == String
            is_uri = false
            begin
              uri = URI.parse(annotation[:value])
              is_uri = true if uri.class == URI::HTTP
            rescue URI::InvalidURIError
              is_uri = false
            end
    
            target_uri =
              if is_uri
                annotation[:value]
              elsif annotation[:value].include?("::")
                eval("#{annotation[:value]}.uri")
              elsif !domain_property.uri.to_s.include?("wikiSeeAlso")
                ActiveRDF::Namespace.register(:dbpediares, 'http://dbpedia.org/resource/')
                ActiveRDF::Namespace.expand(DBPEDIARES.prefix, annotation[:value].gsub(" ", "_"))
              else
                ActiveRDF::Namespace.expand(SWWIKI.prefix, annotation[:value].gsub(" ", "_"))
              end
            
            target_page = SWWIKI::WikiPage.new(target_uri)
            target_page.swwiki::wikiLabel = annotation[:value]
            target_page.swwiki::content = "No content for this page yet"
            add_wiki_triple(page, domain_property, target_page)
          end
        else
    
          prop_without_ns = content.scan(/\[\[[^::]*#{annotation[:propertyName]}==*/)
          adapter.add(domain_property, RDFS::range, XSD::string)
          add_wiki_triple(page, domain_property, annotation[:value])
        end
    
        if !prop_without_ns.empty?
          abbrv_uri = ActiveRDF::Namespace.abbreviate(domain_property)
          prop_with_ns = prop_without_ns[0].gsub(annotation[:propertyName], abbrv_uri )
          page.swwiki::content = content = content.gsub(prop_without_ns[0], prop_with_ns)
        end
      else
        abbreviated = ActiveRDF::Namespace.abbreviate(annotation[:propertyName])
        
        if !(abbreviated.nil?)
          abbr_prop_array = abbreviated.split("::")   
          abbreviated = "#{abbr_prop_array[0].downcase}::#{abbr_prop_array[1]}"
    
          target_objects = eval("page.#{abbreviated}.to_a")
          target_objects.each{|tgt_obj|
            if(tgt_obj.instance_of?(RDFS::Resource))
              tgt_obj.swwiki::wikiLabel = tgt_obj.localname
              tgt_obj.swwiki::content = "No content for this page yet"
            end
          }
        end
      end 
    }
    page.swwiki::content = content
    page.save
  end
  
#
# * Name: generate_rdfa_h1
# * Description: This method generates the RDFa of the first header of the wikipage.
# * Parameters:
#    ** wikipage_uri: the uri of the wikipage
# * Returns:
#    ** A String that is the header h1 of the wikipage
#
  def self.generate_rdfa_h1(wikipage_uri)
    wikipage = RDFS::Resource.new(wikipage_uri)    
    label = ActiveRDF::Query.new.select(:p).where(wikipage, SWWIKI::wikiLabel, :p).execute.first
    
    # generating the RDFa for the label
    rdfa = generate_rdfa_property(SWWIKI::wikiLabel.to_s, label)
    # getting the same resource
    sameResource = get_sameAs(wikipage_uri)
    # generating the link for the element on DBpedia
    uri = "URI: (<a href=\"#{wikipage_uri}\" title=\"Open dbpedia ref in a new tab\" target=\"_blank\">#{wikipage_uri}</a>)" if !wikipage_uri.include?("swwiki")
    # if is not an dbpedia element, do not generate a link
    uri ||= 
    if !sameResource.empty?
      "URI: (<a href=\"#{sameResource.first.uri}\" title=\"Open dbpedia ref in a new tab\" target=\"_blank\">#{sameResource.first.uri}</a>)"
    else
      "URI: (#{wikipage_uri})"
    end
    "<h1>#{rdfa}</h1> 
      #{uri}
    "
  end

#
# * Name: get_sameAs
# * Description: Retrieves s list of elements related by the sameAs construct.
# * Parameters:
#    ** wikipage_uri: the URI of the wikipage
# * Returns: 
#    ** A list of elements related by sameAs with the wikipage_uri
#
  def self.get_sameAs(wikipage_uri)
    wikipage = RDFS::Resource.new(wikipage_uri) 
    ActiveRDF::Query.new.select(:content).where(wikipage, OWL::sameAs, :content).execute.flatten
  end  

#
# * Name: generate_rdfa_rel
# * Description: Generate the RDFa rel markup that relates resources by object properties
# * Parameters:
#    ** prop_uri: The URI of the property that relates the resources
#    ** resource: The URI of the resource that is the object of the triple
# * Returns:
#    ** Nil: if the object property cannot be abbreviated
#    ** A string that is the abbreviated object property
# 
  def self.generate_rdfa_rel(prop_uri, resource)    
  	downcase_abbrv_prop_uri = get_downcase_abbrv_property_uri(prop_uri)
    'rel="%s" resource="%s"'%[downcase_abbrv_prop_uri.to_s, resource]
  end

#
# * Name: add_wiki_triple
# * Description: This operation select wether the triple is new or is an existent triple.
#                  If it's a new triple, creates a local SWWIKI::WikiPage with the namespace SWWIKI and
#                relates the predicate and the object to it.
# * Parameters:
#    ** subject: the wikipage that is the subject of the triple
#     ** predicate: the predicate of the triple
#     ** object: the object of the triple  
#
  def self.add_wiki_triple(subject, predicate, object)
    adapter = ActiveRDF::ConnectionPool.adapters.first
    objects = eval("subject.#{predicate.localname}.to_a")
    
    if !objects.include?(object)  
      local_uri = ActiveRDF::Namespace.expand(SWWIKI.prefix, subject.wikiLabel)
      local_wiki_page = SWWIKI::WikiPage.new(local_uri)
    
      adapter.add(subject, OWL::sameAs, local_wiki_page)
    
      adapter.add(local_wiki_page, predicate, object)
    end
  end
  
#
# * Name: clear_see_also
# * Description: This operation removes all SWWIKI::wikiSeeAlso occurences for a given wikipage.
# * Parameters:
#    ** wikipage_uri: the URI of the wikipage to clear the SWWIKI::wikiSeeAlso relationships
#
  def self.clear_see_also(wikipage_uri)
      wikipage = SWWIKI::WikiPage.new(wikipage_uri)
    result_list = Application.jena_adapter.execute(ActiveRDF::Query.new.select(
            :see_also).where(wikipage, SWWIKI::wikiSeeAlso, :see_also)).flatten
    result_list.each{|see_also_object|
      Application.jena_adapter.delete(wikipage, SWWIKI::wikiSeeAlso, see_also_object)
    }
  end

#
# * Name: clear_ignored_markups
# * Description: removes all <pre> declarations
# * Parameters:
#    ** text: the text with <pre> declarations
# * Returns:
#    ** A string without <pre> declarations 
#
  def self.clear_ignored_markups(text)
    text.gsub(/<pre>.*\<\/pre>/, "")
  end 
 
#
# * Name: generate_rdfa_property
# * Description: Generate the RDFa property markup that relates resources and values by datatype properties
# * Parameters:
#    ** prop_uri: The URI of the property that relates the resources
#    ** object: The value that is the object of the triple
# * Returns:
#    ** Nil: if the object property cannot be abbreviated
#    ** A string that is the abbreviated datatype property
#
  def self.generate_rdfa_property(prop_uri, object)    
  	downcase_abbrv_prop_uri = get_downcase_abbrv_property_uri(prop_uri)  	
    '<span property="%s">%s</span>'%[downcase_abbrv_prop_uri.to_s, object]
  end
  
#
# * Name: get_downcase_abbrv_property_uri
# * Description: Generate the downcase abbreviated uri for a uri. Ex: dbpedia:Ronaldinho
# * Parameters:
#    ** uri: The URI to be abbreviated#    
# * Returns:
#    ** Nil: if the object property cannot be abbreviated
#    ** A string that is the abbreviated uri
#
  def self.get_downcase_abbrv_property_uri(uri)
    abbrv_ns = ActiveRDF::Namespace.abbreviate(uri)
    downcase_abbrv_prop_uri = nil
    if abbrv_ns
		  splitted_ns = abbrv_ns.split("::") 
		  downcase_abbrv_prop_uri  = "#{splitted_ns[0].downcase}:#{splitted_ns[1]}"
    end
    downcase_abbrv_prop_uri
  end
#
# * Name: extract_dbpedia_resource_value_property_hash
# * Description: This operation extracts a dictionary of properties indexed by its values querying the 
# 				 DBpedia. This hash is necessary to find the appropriate property of a markup in the raw text.
# * Parameters:
#	** dbpedia_resource: the RDFS::Resource from DBpedia 
# * Returns: 
#	** A dictionary of properties indexed by its values    
#
  def self.extract_dbpedia_resource_value_property_hash(dbpedia_resource)

    result_set = ActiveRDF::Query.new.select(:p, :o).where(dbpedia_resource, :p, :o).execute
    value_property_hash = {}
    result_set.each{|pair|
        value_property_hash[pair[1].to_s] = [pair[0]].to_s
    }
    value_property_hash        
  end
  
#
# * Name: find_by_label
# * Description: This operation queries the DBpedia for a specific resource with a given label.
# * Parameters:
#	** label: The resource label.
# * Returns:
# 	** The first RDFS::Resource found with the label
#
  def self.find_by_label(label)
    sparql_adapter = Application.load_dbpedia_endpoint
    sparql_adapter.execute_sparql_query("select ?p where{?p rdfs:label '#{label}'@en}").flatten.first  
  end  
  
#
# * Name: import_dbpedia_resource
# * Description: Imports a DBpedia resource identified by the name
# * Paramters:
# 	** name: the name of the resource
# * Returns:
# 	** A RDFS::Resource with the dbpedia uri 
#
  def self.import_dbpedia_resource(name)
    name = name.gsub(" ", "_")
    Application.load_dbpedia_endpoint
    res = RDFS::Resource.new("http://dbpedia.org/resource/#{name}")       
  end
  
#
# * Name: import_raw_wikipedia_page
# * Description: Imports the raw content of a Wikipedia page.
# * Parameters:
#	** wikipedia_page_name: The name of the Wikipedia page
# * Returns
#	** The raw Wikipedia text
#

  def self.import_raw_wikipedia_page(wikipedia_page_name)
   require 'net/http'

    Net::HTTP.start("en.wikipedia.org") { |http|
      resp = http.get("/wiki/#{wikipedia_page_name}?action=raw", 'User_Agent' => 'swwiki')
      return resp.body.to_s
    }
    raise "Page not found"
  end  
  
#
# * Name: generate_semantic_markup
# * Description: Generates a dictionary of semantic markups indexed by the original Wikipedia markups.
# * Parameters:
# 	** raw_link_markup_list: A list of original Wikipedia markups. Each element of this list is
# 	   an array of two elements. The first is the markup with brackets and the second is the markup
# 	   without brackets.
# 	** value_prop_hash: The dictionary of properties indexed by its values.
# * Returns:
#	** A dictionary of semantic markups indexed by the original markups   
#
  def self.generate_semantic_markup(raw_link_markup_list, value_prop_hash)
    semantic_markup_hash = {}
    raw_link_markup_list.each{|link_markup|      
	  #finding the property for the wikipedia markup 
      prop = value_prop_hash[link_markup[1]]	  
      prop ||= value_prop_hash["http://dbpedia.org/resource/#{link_markup[1].gsub(" ", "_")}"]
      value = link_markup[0]
      semantic_markup = "[[#{link_markup[1]}]]" if prop.nil?
	  # if there's a property for the value, create a semantic link markup
      semantic_markup ||= "[[#{ActiveRDF::Namespace.abbreviate(prop)}->#{link_markup[1]}]]" 
      aliased = value.include?("|")
      has_bending = !value.split("]]")[1].nil?     
      link_alias = ""
	  
	  # treatment for an aliased markup
      if aliased       
        link_alias = value.split("|")[1].split("]]")[0]
        semantic_markup = semantic_markup.gsub(link_markup[1], link_markup[1].split("|")[0])
      end
      semantic_markup = semantic_markup.gsub("[[", "[[#{link_alias}|") unless link_alias.empty?
      semantic_markup_hash[link_markup[0]] = semantic_markup
    }
    semantic_markup_hash
  end
  
#
# * Name: extract_link_markup
# * Description: Extracts all markups from the raw Wikipedia text
# * Parameters:
#	** text: raw Wikipedia text
# * Returns:
#	** A list of markups extracted from the raw text
#
  def self.extract_link_markup(text)
	# scanning for markups
    annotMatches = text.to_s.scan(/(\[\[([^\]]*)\]\])/)   
    annotMatches
  end

  def self.init_timer
    tbegin = Time.now
    tbegin.to_i
  end  

  def self.end_timer(time_begin, msg)
    time_end = Time.now.to_i
    time_total = time_end - time_begin    
  end  

  def self.tempo(sec)
   min = (sec/60)
   sec_min = min * 60
   rest_sec = (sec - sec_min)
   "#{min.to_s.rjust(2,'0')}:#{rest_sec.to_s.rjust(2,'0')}"
  end
 
#
# * Name: create_swikipage
# * Description: Creates the semantic wiki page from a given Wikipedia page calling the other methods of the module.
# * Parameters:
#	** wikipedia_page_name: The name of the Wikipedia page
# * Returns:
#	** A new SWWIKI::WikiPage
#
  def self.create_swikipage(wikipedia_page_name)
    label = wikipedia_page_name.dup	
    wikipedia_page_name = wikipedia_page_name.gsub(" ", "_")
	# importing resource from DBpedia
    dbpedia_resource = self.import_dbpedia_resource wikipedia_page_name
	# extracting a hash of properties indexed by values
    value_prop_hash = self.extract_dbpedia_resource_value_property_hash(dbpedia_resource)
	# getting the raw wiki text from Wikipédia
    raw_wikipedia_text = self.import_raw_wikipedia_page wikipedia_page_name
	#extracting markups from the raw Wikipédia text
    link_markup_list = self.extract_link_markup raw_wikipedia_text
	# generating the semantic markups
    sem_markup_hash = self.generate_semantic_markup(link_markup_list, value_prop_hash)
	# replacing the original markups by the semantic markups
    sem_markup_hash.each{|markup_key, sem_markup|      
      raw_wikipedia_text = raw_wikipedia_text.gsub(markup_key, sem_markup)
    }
    local_resource = Application.jena_adapter.execute(ActiveRDF::Query.new.select(:p).where(:p, SWWIKI::wikiLabel, label)).flatten.first
	
	# creating or loading the equivalent SWWIKI::WikiPage
    if(local_resource)
      dbpedia_resource = local_resource
    else
      dbpedia_resource = SWWIKI::WikiPage.new(dbpedia_resource.uri)
    end
    Application.jena_adapter.add(dbpedia_resource, SWWIKI::wikiLabel, label)
    Application.jena_adapter.add(dbpedia_resource, SWWIKI::content, raw_wikipedia_text)     
    dbpedia_resource = dbpedia_resource.save    
    dbpedia_resource
  end

 end
