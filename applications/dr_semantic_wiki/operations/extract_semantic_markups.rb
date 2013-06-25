require 'uri'  
def self.log_extract(msg)
  File.open('./log/extract_semantic_markups.log', 'a'){|f| f.write(msg << "\n")}
end



text = content

annotations = Array.new()

text = Operations.clear_ignored_markups({:text=>text})
annotMatches = text.scan(/(\[\[([^\]]*)\]\])/)

name1_idx = 0
alias_token_idx = 1
name2_idx = 2
predicate_token_idx = 3
name3_idx = 8

annotMatches.each { |annotMatch|

  if !((annotMatch[1].include?("File:")) || (annotMatch[1].include?("Image:")))
  
    annotMatch[1].scan(/-([^>])/).each{|pos_ifen_char| annotMatch[1].gsub!("-#{pos_ifen_char}", "ifen#{pos_ifen_char}")}
    
    annotParts = annotMatch[1].scan(/([^\|\-\>\=\?]*)(\|?)([^\->\=\?]*)(((\=)|(\-\>)|(\?\?))?)(.*)/)[0]			
    annotParts = annotParts.map{|annotPart| annotPart.to_s.gsub("ifen", "-")}
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
  end
}  

annotations 
