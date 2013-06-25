require 'uri'
def self.log_render(msg)

  File.open('./log/renderTargetPage.log', 'a'){|f| f.write(msg << "\n")}
  
end
log_render params.inspect
tgt_ctx = params[:tgtctx]
tgt_resource = params[:tgtresource]
tgt_class = params[:tgtclass]
wikiLabel = params[:wikiLabel]
wiki_page = SWWIKI::WikiPage.find_by.swwiki::wikiLabel(wikiLabel).execute.first

uri_part = wikiLabel.gsub(" ", "_")

log_render wiki_page.uri
classes = wiki_page.classes.to_a
classes.delete(SR::Node)
classes.delete(SR::AbstractWikiPage)
classes.delete(RDFS::Resource)
classes.delete(RDF::Resource)
classes.delete(SR::AbstractModel)
classes.delete(SR::WikiPage)
classes.delete(SWWIKI::WikiPage)
classes << SWWIKI::WikiPage if classes.empty?
if classes.size == 1 && classes.first == SWWIKI::WikiPage
  url = "/execute/context/http%3A%2F%2Fbase%23c11f6410-1197-11e2-b893-bc773740354f?node=#{CGI.escape(tgt_resource)}&firstchar=#{wikiLabel[0].chr}"
else
  url = "/execute/context/#{CGI.escape(tgt_ctx)}?node=#{CGI.escape(tgt_resource)}&klass[resource]=#{CGI.escape(classes.first.uri.to_s)}"
end
wiki_page.swwiki::content = "No content for this page yet!" unless wiki_page.swwiki::content.to_s != ""
redirect_to(url)