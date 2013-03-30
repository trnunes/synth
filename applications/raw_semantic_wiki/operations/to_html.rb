
		require 'wikicloth'
    require 'cgi'
		wikipage_uri = wikipageuri
		def self.log_to_html(msg)
			File.open('./log/to_html.log', 'a'){|f| f.write(msg << "\n")}
		end

    def time
      start = Time.now
      yield
      diff =  Time.now - start
      log_to_html("EXECUTION TIME: #{diff.to_s}")
    end


time do		
    wikipage = RDFS::Resource.new(wikipage_uri)
    
    #rendering all semantic markups
		

    arr = Operations.render_semantic_markups({:wikipage_uri=>wikipage_uri})
  
    
    text =arr.first
    log_to_html(text)
    @rdfa_hash = arr.last
    
    #this is necessary due to an issue of the Wikicloth engine that do not 
    #handle the ".*" string pattern    
    # html = WikiCloth::WikiCloth.new({:data => text.gsub("\.", ". ")}).to_html
    html = CGI::unescapeHTML(WikiCloth::WikiCloth.new({:data => text}).to_html)
    log_to_html("UNESCAPED: " + CGI::unescapeHTML(html))
    #this is necessary because another issue of the Wikicloth that inserts an space
    #on the pattern 'target="_blank"' causing an html error
    html = html.gsub(' target="_blank"', "")
    
    # html = html.gsub(". ", "\.")
    
    #generation of RDFa
    @rdfa_hash.each_pair{|html_markup, rdfa_markup|
      html = html.gsub(html_markup, rdfa_markup) unless rdfa_markup.nil?
    }
    
    #generation of first header
		
    result = Operations.generate_rdfa_h1({:wikipage_uri=>wikipage_uri}) << "\n"+html
		
end
		result