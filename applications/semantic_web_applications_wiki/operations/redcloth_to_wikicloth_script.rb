def self.log(msg)

  File.open('./log/migrate_pages.log', 'a'){|f| f.write(msg << "\n")}
  
end

pages = SR::WikiPage.find_all
pages.each{|p|
  label = p.sr::wikiLabel.to_s
  text = p.sr::wikiText.to_s
  ## threating links ##  
  text = text.gsub(/\[([^\]]*)\]/){|internal_link|internal_link.gsub("[", "[[").gsub("]", "]]")}
  external_links = text.scan(/("([^"].*)":(http?:\/\/[\S]+))/).map{|match| 
    last_chr = match[2][match[2].size - 1].chr
    if last_chr == "."
      match[2][match[2].size - 1] = ""
      match[0][match[0].size - 1] = ""
    end
    match
  }
  links_to_gsub = external_links.map{|match| [match[0], "[#{match[2]} #{match[1]}]"]}
  links_to_gsub.each{|ext_link| text = text.gsub(ext_link[0], ext_link[1])}
  external_links = text.scan(/("([^"].*)":(http?:\/\/[\S]+))/).map{|match| 
    last_chr = match[2][match[2].size - 1].chr
    if last_chr == "."
      match[2][match[2].size - 1] = ""
      match[0][match[0].size - 1] = ""
    end
    match
  }
  links_to_gsub = external_links.map{|match| [match[0], "[#{match[2]} #{match[1]}]"]}
  links_to_gsub.each{|ext_link| text = text.gsub(ext_link[0], ext_link[1])}
  
  text = text.gsub(/\*[^\*].*\*/){|bold| bold.gsub("*", "'''")}
  # text = text.gsub(/[^\[]*_[^_]*_*[^\]]/){|italic_string| italic_string.gsub("_", "''")}
  h_tag = '=='
  header_list = text.scan(/(h([[:digit:]])\. (.*))/).map{|header| 
    h_tag = '=='
    [header[0], "#{(header[1].to_i - 1).times do h_tag += "=" end; h_tag}#{header[2]}#{h_tag}"]
  }.each{|header_to_sub| text = text.gsub(header_to_sub[0], header_to_sub[1])}
  text = text.gsub(/(\[\[([^\]]*)\]\])/){|t|t.gsub(":=", "=")}
    
  p.rdf::type.to_a << SWWIKI::WikiPage
  p.swwiki::wikiLabel = label
  p.swwiki::content = text.to_s
  if(label == "WSDL")
    log("ORIGINAL: " + p.sr::wikiText.to_s)
    log("MODIFIED: " + p.swwiki::content.to_s)
    
  end
  p.save
}
require 'cgi'
repository_path = "./applications/raw_semantic_wiki/attachments"
adapter = ActiveRDF::ConnectionPool.adapters.first  
SR::AttachedFile.find_all.each{|at_file|
  wikipage = at_file.sr::node_id.to_a.first
  attachment = at_file.sr::target_node_id.to_a.first
  
  attachment.rdf::type.to_a << SWWIKI::FileAttachment
  attachment_id = attachment.uri.to_s.split("#").last
  attachment_name = attachment.sr::name.to_s
  
  attachment.save  
  path = repository_path + "/" + attachment_id + "_" + attachment_name
  attachment.swwiki::attachmentName = []
  attachment.swwiki::path = []
  attachment.swwiki::link = []
  attachment.save 
  attachment.swwiki::attachmentName = attachment_name
  attachment.swwiki::path = path
  attachment.swwiki::link = "/execute/download_attachment?uri=#{CGI::escape(attachment.uri)}"  
  attachment.save 
  adapter.add(wikipage, SWWIKI::hasAttachment, attachment)
  wikipage.save
}
SR::FileAttachment.find_all.each{|a| a.swwiki::link = "/execute/download_attachment?uri=#{CGI::escape(a.uri)}" ; a.save}
