# dr_json = File.read("applicat ions/dr_semantic_wiki/ontologies/#{params[:file_name]}.js")
# parsed_json = JSON.parse(dr_json)
# parsed_dr["questions"] = parsed_dr["questions"][1..parsed_dr["questions"].size] 
# type = parsed_dr["questions"].first["rdf::type"].first
# reasoning_element_resource = RDF::Resource.new(parsed_dr["questions"].first["uri"])
# eval("reasoning_element_resource.#{property} << #{type}")
json = '{
    "namespaces": {
        "nm1": "http://local/n/",
        "nm2": "http://local/n2/"
    },
    "resources": [
        {
            "uri": "NM1::object_prop2",
            "rdf::type": "RDF::Property",
            "rdfs::domain": "NM1::Classe1"             
        },
        {
            "uri": "NM1::resource3",           
            "nm1::object_prop2": "NM1::resource2"            
        },
        {
            "uri": "NM1::resource1",
            "rdf::type": "NM1::Classe1",
            "nm1::single_valued_prop": "single value",
            "nm1::multivalued_valued_prop": [
                "value1",
                "value2",
                "value3"
            ],
            "nm1::object_prop1": [
                "NM1::resource2"
            ]
        },
        {
            "uri": "NM1::resource2",
            "rdf::type": "NM1::Classe2",
            "nm1::single_valued_prop": "single value",
            "nm1::int_prop": 1,
            "nm1::multivalued_valued_prop": [
                "value1",
                "value2",
                "value3"
            ]            
        }
        
    ]
}'
parsed_json = JSON.parse(json)
elements = []
parsed_json['namespaces'].each_key{|prefix|
  uri = parsed_json['namespaces'][prefix]
  ActiveRDF::Namespace.register(eval(":#{prefix}"), uri)
}

parsed_json['resources'].each{|instance_hash|
  resource = RDF::Resource.new(eval(instance_hash.delete('uri')).to_s)
  resource.destroy
  instance_hash.each_key{|property|
      attribution_operator = "="
      value = instance_hash[property]
      if(value.class == Array)
        attribution_operator = "<<"              
      else
        value = [value]
      end      
        value.each{|v|
          if(v.class == String)          
            if(v.include?("::"))
              eval("resource.#{property} #{attribution_operator} #{v}")
            else            
              eval("resource.#{property} #{attribution_operator} \"#{v}\"")
            end
          else
            eval("resource.#{property} #{attribution_operator} #{v}")            
          end          
        }       
  }
  resource.save
}
