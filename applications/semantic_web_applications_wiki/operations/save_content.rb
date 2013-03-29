require 'uri'    
ActiveRDF::Namespace.register(:swwikires, "http://swwiki/resource/")

def self.log_save(msg)

  File.open('./log/save_content.log', 'a'){|f| f.write(msg << "\n")}
  
end

def find_property_by_label(label)

  RDF::Property.find_by.rdfs::label(label).execute.first    
  
end

def create_new_local_property(label)

  prop_uri = ActiveRDF::Namespace.expand(SWWIKI.prefix, label)
  domain_property = RDF::Property.new(prop_uri)
  domain_property.rdfs::label = label
  domain_property.save
  domain_property
  
end

def is_uri?(string_to_verify)

  !(string_to_verify =~ URI::regexp).nil?
  
end

def value_has_namespace?(value_to_verify)

  value_to_verify.include?("::")
  
end

def create_local_uri_for_resource(resource_label)

  ActiveRDF::Namespace.expand(SWWIKIRES.prefix, resource_label.gsub(" ", "_"))    
  
end

def create_empty_wikipage(resource_uri, wikilabel)

  log_save("	CREATING TARGET PAGE: #{resource_uri}")				
  
  empty_page = SWWIKI::WikiPage.new(resource_uri)						
  empty_page.swwiki::wikiLabel = wikilabel
  
  log_save("	ADDING LABEL: #{empty_page.swwiki::wikiLabel.to_s}")												
  
  empty_page.swwiki::content = "No content for this page yet"
  empty_page
  
end


def add_datatype_value(source_page, datatype_property, data_value)

  # The wiki language should allow the definition of cardinality for the propertys
  # The navigational properties bellow must have cardinality of 1.
  
  if (datatype_property == SHDM::context_query)
  
    source_page.shdm::context_query = data_value
    
  elsif (datatype_property == SHDM::context_title)
  
    source_page.shdm::context_title = data_value    
    
  elsif(datatype_property == SHDM::landmark_position)
    
    source_page.shdm::landmark_position = data_value
  
  else
  
    Operations.add_wiki_triple({:subject=>source_page.uri, :predicate=>datatype_property.uri, :object=>data_value, :is_resource=>0})    
    
  end
  
end

def relate_wikipages(source_page, relation, target_page)

  adapter = ActiveRDF::ConnectionPool.adapters.first
  adapter.add(source_page, relation, target_page)
  
end   


def handle_datatype_property_value(wikipage, datatype_property, value)

  adapter = ActiveRDF::ConnectionPool.adapters.first
  adapter.add(datatype_property, RDFS::range, XSD::string)
  
  log_save("	adding datatype property triple")
  
  log_save("		#{wikipage.uri} #{datatype_property.uri} #{value}")
  
  add_datatype_value(wikipage, datatype_property, value)
  
end

def handle_object_property_value(source_page, object_property, value)

  if value.class == String	
  
    target_uri =
      if is_uri?(value)
        value
      elsif value_has_namespace?(value)
        eval("#{value}.uri")
      else
        create_local_uri_for_resource(value)
      end        
      
    target_page = create_empty_wikipage(target_uri, value)
    
    log_save("	ADDING OBJECT TRIPLE: ")
    
    log_save("  	#{source_page.uri} #{object_property.uri} #{target_page.uri}")
    
    relate_wikipages(source_page, object_property, target_page)        
  else
  
    log_save("	ADDING EXISTENT OBJECT TRIPLE")
    
    log_save("		#{source_page.uri} #{object_property.uri} #{value.uri}")
    
    relate_wikipages(source_page, object_property, value)        
    
  end
  value  
end

def handle_property(property_name)
  if !is_uri?(property_name)
    domain_property = find_property_by_label(property_name)
    # if property does not exists create
    if(!domain_property)
      domain_property = create_new_local_property(property_name)
    end                 
  else
    domain_property = RDF::Property.new(property_name)
  end      
  
  log_save("	DOMAIN PROPERTY: #{domain_property}")
  
  domain_property
end

def replace_for_property_with_namespace(domain_property, markup, wikitext)

  abbrv_uri = ActiveRDF::Namespace.abbreviate(domain_property)
  if !abbrv_uri.include?("SWWIKI")
    prop_with_ns = markup.gsub(semantic_markup[:propertyName], abbrv_uri )
    wikitext.gsub!(markup, prop_with_ns)
  end
  
end

def handle_landmark(landmark_page, context_page)
  nav_attr_hash = {
    :context_anchor_navigation_attribute_target_context => context_page,
    :context_anchor_navigation_attribute_label_expression => "'#{context_page.shdm::context_title.to_s}'"
  }
  
  nav_attr = SHDM::ContextAnchorNavigationAttribute.create(nav_attr_hash).save
  landmark_page.rdf::type.to_a << SHDM::Landmark
  
  landmark_page.shdm::landmark_navigation_attribute = nav_attr
  
  
  landmark_page.save
  log_save("LANDMARK: #{landmark_page.uri}")
end

def handle_query_property(query_property)

  abbreviated = ActiveRDF::Namespace.abbreviate(query_property)
  
  if !(abbreviated.nil?)
    abbr_prop_array = abbreviated.split("::")   
    abbreviated = "#{abbr_prop_array[0].downcase}::#{abbr_prop_array[1]}"

    target_objects = eval("source_page.#{abbreviated}.to_a")
    
    target_objects.each{|tgt_obj|
      if(tgt_obj.instance_of?(RDFS::Resource))
        tgt_obj.rdf::type << SWWIKI::WikiPage
        tgt_obj.swwiki::wikiLabel ||= tgt_obj.localname
        tgt_obj.swwiki::content ||= "No content for this page yet"
      end
    }
    
  end
  
end

def create_interctx(interctx_page)
 log_save("CONTEXTS ALREADY CREATED")
  ## context_title
  ## klass
  ## property
  ## index_label
  log_save interctx_page.rdfs::label.to_a.first.to_s
  interctx_page.swwiki::domain_class ||= SWWIKI::WikiPage
  
  interctx_page.swwiki::title_of_context = interctx_page.rdfs::label.to_a.first.to_s if interctx_page.swwiki::title_of_context.to_a.empty?
  
  interctx_page.swwiki::index_label = interctx_page.rdfs::label.to_a.first.to_s if interctx_page.swwiki::index_label.to_a.empty?
  
  # log_save("CONTEXTS ALREADY CREATED")
  require 'uuidtools'
  id = UUIDTools::UUID.random_create.to_s
  context_title = interctx_page.swwiki::title_of_context.to_a.last.to_s
  # klass = interctx_page.swwiki::domain_class.to_a.last.to_s
  klass = SWWIKI::WikiPage
  property = interctx_page.swwiki::property.to_a.last.to_s
  
  if(property.empty?)
    return
  end
  
  index_label = interctx_page.swwiki::index_label.to_a.last.to_s
  log_save("CONTEXTS ALREADY CREATED 6")
  if(property.include?("::"))
    property = property.split("::")[0].downcase + "::"+ property.split("::")[1]
  else
    property = "swwiki::#{property}"
  end
  
  if (!interctx_page.swwiki::inter_context.to_a.empty?)    
    log_save("CONTEXTS ALREADY CREATED")
    log_save("interctx-page: #{interctx_page.swwiki::content.to_s}" )
    context = interctx_page.swwiki::inter_context.to_a.first
    log_save("passei context retrieval" )
    context_param = context.shdm::context_parameters.to_a.first    
    index = interctx_page.swwiki::inter_context_index.to_a.first
    log_save("passei index retrieval" )
    ctx_param = index.shdm::context_anchor_attributes.to_a.first
    param2 = ctx_param.shdm::context_anchor_navigation_attribute_target_parameters.to_a.first
    inctxClass = interctx_page.swwiki::in_context_class.to_a.first
    log_save("passei incontext class retrieval" )
    index_nav_attr = inctxClass.shdm::in_context_class_index_attributes.to_a.first
    param = index_nav_attr.shdm::index_navigation_attribute_index_parameters.to_a.first
  else
    log_save("CONTEXT IS NEW")
    log_save("interctx-page: #{interctx_page.swwiki::content.to_s}" )
    param = SHDM::NavigationAttributeParameter.new("http://base#"+id)
    context_param = SHDM::ContextParameter.new("http://base#"+UUIDTools::UUID.random_create.to_s)    
    param2 = SHDM::NavigationAttributeParameter.new("http://base#"+UUIDTools::UUID.random_create.to_s)
    context = SHDM::Context.new("http://base#"+UUIDTools::UUID.random_create.to_s)
    interctx_page.swwiki::inter_context = context
    log_save("passei context association" )
    ctx_param = SHDM::ContextAnchorNavigationAttribute.new("http://base#"+UUIDTools::UUID.random_create.to_s)
    index = SHDM::ContextIndex.new("http://base#"+UUIDTools::UUID.random_create.to_s)
    interctx_page.swwiki::inter_context_index = index
    log_save("passei index association" )
    inctxClass = SHDM::InContextClass.new("http://base#"+UUIDTools::UUID.random_create.to_s)
    interctx_page.swwiki::in_context_class = inctxClass
    log_save("passei incontext class association" )
    index_nav_attr = SHDM::IndexNavigationAttribute.new("http://base#"+UUIDTools::UUID.random_create.to_s)
    interctx_page.save
  end
  
    param.shdm::navigation_attribute_parameter_name = "param"
    param.shdm::navigation_attribute_parameter_value_expression = "self"
    param.rdfs::label = "param"
    param.save
    log_save("passei por param")    
    
    context_param.shdm::context_parameter_name = "param"
    context_param.save    
    
    param2.shdm::navigation_attribute_parameter_name = "param"
    param2.shdm::navigation_attribute_parameter_value_expression = "parameters[:param]"
    param2.rdfs::label = "param"
    param2.save
    log_save("passei por param")
    
    context.shdm::context_query  = "param.#{property}.to_a"
    context.shdm::context_title = context_title
    context.shdm::context_name = context_title
    context.shdm::context_parameters = context_param 
    context_param.shdm::parameter_context = context
    context.save
    context_param.save
    
    log_save("passei por context")
    
    ctx_param.shdm::context_anchor_navigation_attribute_label_expression  = "label = self.rdfs::label\n unless label.nil? || label.to_a.empty?\n label\n else\n self.compact_uri\n end\n "
    ctx_param.shdm::context_anchor_navigation_attribute_target_context = context
    ctx_param.shdm::context_anchor_navigation_attribute_target_node_expression = "self"
    ctx_param.shdm::context_anchor_navigation_attribute_target_parameters = param2
    ctx_param.shdm::navigation_attribute_index_position = "1"
    ctx_param.shdm::navigation_attribute_name = index_label
    ctx_param.rdfs::label = index_label
    ctx_param.save
    log_save("passei por context param")

    
    index.shdm::context_anchor_attributes = ctx_param
    index.shdm::context_index_context = context
    index.shdm::index_attributes = ctx_param
    index.shdm::index_name = index_label + "Idx"
    index.shdm::index_title = index_label
    index.shdm::label = index_label
    index.save
    log_save("passei por index")

    
    inctxClass.shdm::in_context_class_class = SWWIKI::WikiPage
    inctxClass.shdm::in_context_class_context = SHDM::Context.new("http://shdm#anyContext")
    inctxClass.save
    log_save("passei por context in context class")
    
    
    index_nav_attr.shdm::index_navigation_attribute_index = index
    index_nav_attr.shdm::index_navigation_attribute_index_parameters = param
    index_nav_attr.shdm::navigation_attribute_name = index_label
    index_nav_attr.shdm::navigation_attribute_parent = inctxClass
    index_nav_attr.rdfs::label = index_label
    index_nav_attr.save
    
    inctxClass.shdm::in_context_class_index_attributes  = index_nav_attr
    inctxClass.shdm::in_context_class_navigation_attributes = index_nav_attr
    inctxClass.save
  

end

#### BEGIN EXECUTION ####

  log_save("SAVING WIKI CONTENT FOR: #{wikipage_uri}")

  adapter = ActiveRDF::ConnectionPool.adapters.first
  source_page = SWWIKI::WikiPage.new(wikipage_uri)
  text = content

  markup_hash = Operations.extract_semantic_markups({:content=> text})

  markup_hash.each { |semantic_markup|

    log_save("MARKUP: #{semantic_markup[:match]}")
    
    log_save("	VALUE: #{semantic_markup[:value]} => #{semantic_markup[:value].class}")
    
    if(!semantic_markup[:query])			
     
      domain_property = handle_property(semantic_markup[:propertyName])
      
      if semantic_markup[:objectProperty]
        property_without_namespace = content.scan(/\[\[[^::]*#{semantic_markup[:propertyName]}--*/)[0]        
        target_page = handle_object_property_value(source_page, domain_property, semantic_markup[:value])
        
        if semantic_markup[:propertyName].to_s.include?("landmark_context")
          handle_landmark(source_page, target_page)
        end        
        
      else
        handle_datatype_property_value(source_page, domain_property, semantic_markup[:value])
        property_without_namespace = content.scan(/\[\[[^::]*#{semantic_markup[:propertyName]}==*/)[0]			
      end

      if property_without_namespace
        replace_for_property_with_namespace(domain_property, property_without_namespace, content)      
      end
      
    else
    
      handle_query_property(semantic_markup[:propertyName])

    end 
  }
  source_page.swwiki::content = content
  source_page.save
  
  log_save(source_page.classes.inspect)
  if(source_page.classes.include?(SWWIKIRES::InterContextIndex))
    log_save "is interctx"
    create_interctx(source_page)
  end
  source_page.save
#### END EXECUTION ####
