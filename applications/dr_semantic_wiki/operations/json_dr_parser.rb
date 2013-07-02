dr_json = File.read("applications/dr_semantic_wiki/ontologies/#{params[:file_name]}.js")
parsed_dr = JSON.parse(dr_json)
# parsed_dr["questions"] = parsed_dr["questions"][1..parsed_dr["questions"].size] 
# type = parsed_dr["questions"].first["rdf::type"].first
# reasoning_element_resource = RDF::Resource.new(parsed_dr["questions"].first["uri"])
# eval("reasoning_element_resource.#{property} << #{type}")
elements = []

parsed_dr.each_key{|key|
  reasoning_elements = parsed_dr[key]
  reasoning_elements.each{|re|

    reasoning_element_resource = RDF::Resource.new(re["uri"])
    reasoning_element_resource.swwiki::content = ""
    puts re.keys.each{|property|
      if !(property == "uri")
        if(re[property].class == Array)
          values = re[property]
          if(property.include?("content"))
            eval("reasoning_element_resource.#{property} = \"#{re[property].join}\"")
          elsif(property.include?("type"))
            eval("reasoning_element_resource.#{property} = #{re[property].first}")
            
          else
            values.each{|value| 
             eval("reasoning_element_resource.#{property} << RDF::Resource.new(\"#{value}\")")             
             }
          end        
        else
          value = re[property]
          puts "reasoning_element_resource.#{property} = \"#{value}\""
          eval("reasoning_element_resource.#{property} = \"#{value}\"")
          
        end
      end
      
    }
    reasoning_element_resource.save
    elements << reasoning_element_resource    
  }
  

}
puts elements.inspect

elements.each{|element|
  wiki_text = element.swwiki::content.to_s
  predicate_and_objects = ActiveRDF::Query.new.select(:p, :o).where(element, :p, :o).execute
  wiki_text += "\n\n==Relações==\n"
  predicate_and_objects.each{|p_and_o|
    p = p_and_o.first
    p_abbreviated_uri = ActiveRDF::Namespace.abbreviate(p)
    if (p_abbreviated_uri.include?("DR::"))
      o = p_and_o.last
      if(o.is_a?(RDF::Resource))
        wiki_label = o.swwiki::wikiLabel.to_s
        wiki_text += "#{p_abbreviated_uri.split("::").last}: [[#{p_abbreviated_uri.split("::").last}->#{wiki_label}]]\n\n"
      else
        wiki_text += "#{p_abbreviated_uri.split("::").last}: [[#{p_abbreviated_uri.split("::").last}=#{o.to_s}]]\n\n"
      end      
    end    
  }
  puts "ELEMENT: #{element.to_s}"
  element.swwiki::content = wiki_text
  element.save    
}
