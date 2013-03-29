def self.log_save(msg)

  File.open('./log/save_page.log', 'a'){|f| f.write(msg << "\n")}
  
end

def import_dataset(attachment)
  #setting the format of the RDF file to be imported
  format  = 'rdfxml'
  app    = Application.active
  # log_imp("app: #{app.inspect}")
  app.db.load(attachment.swwiki::path.to_s, format, nil)
end

log_save "PARAMS: " + params.inspect
node_url = params[:node_id]
log_save "LABEL: " + params[:current_node][:wikiLabel].to_s
@wiki_page = SWWIKI::WikiPage.find_by.swwiki::wikiLabel(params[:current_node][:wikiLabel]).execute.first
log_save "PAGE: " + @wiki_page.to_s
page_uri = @wiki_page.uri
content = params[:current_node][:content]
Operations.save_content({:wikipage_uri=>page_uri, :content=>content})

removeAttachments = []
attachmentsSize = params[:attachments_size].to_i
i = 0
while i < attachmentsSize 
  removeAttachments << params["remove_attachment_" + i.to_s]
  i = i + 1
end
removeAttachments.compact.each{|uri|
  log_save("REMOVE ATT: " + uri)
  at = SWWIKI::Attachment.new(uri)
  
  File.delete(at.swwiki::path.to_s)
  log_save("DESTROYING: " + uri)
  at.destroy
}
log_save("END DESTROYING: ")
attachments = []
attachmentsFieldsSize = params[:attachments_fields_size].to_i

i = 0
while i < attachmentsFieldsSize
  attachments << params[:node]["attachment_" + i.to_s]
  i = i + 1
end

repository_path = "./applications/#{Application.active.name}/attachments"
adapter = ActiveRDF::ConnectionPool.adapters.first  
log_save("HANDLE ATTACHMENTS") 
log_save(attachments.inspect)  
attachments.each{ |attParam|  
  log_save("NAME: " + attParam.inspect) 
  attachment_id = UUIDTools::UUID.random_create.to_s
  log_save("ID: " + attachment_id) 
  attachment_name = attParam.original_filename.to_s
  log_save("NAME: " + attachment_name) 
  attachment_path = repository_path + "/" + attachment_id + "_" + attachment_name
  attachment_uri = "swwiki:" + attachment_id + "_" + attachment_name
  log_save("URI: " + attachment_uri) 
  attachment = SWWIKI::FileAttachment.new("http://swwiki/attachment/" + attachment_id) 
  attachment.save
  log_save("PASSEI CREATE")  
  log_save("NAME: " + attachment_name.class.to_s)  
  log_save("PROPERTY: " + SWWIKI::attachmentName.to_s)  
  adapter.add(attachment, SWWIKI::attachmentName, attachment_name)
  log_save("PASSEI NAME")
  adapter.add(attachment, SWWIKI::path, attachment_path)
  adapter.add(attachment, SWWIKI::link, "/execute/download_attachment?uri=#{attachment.uri}")
  log_save("PASSEI PATH")
  file = File.new(attachment.swwiki::path.to_s, "wb")
  file.write attParam.read
  file.close
  
  adapter.add(@wiki_page, SWWIKI::hasAttachment, attachment)
  @wiki_page.save
  if(@wiki_page.classes.include?(SWWIKI::Dataset))
    import_dataset(attachment)
  end

}


redirect_to(node_url)