def self.log_save_attach(msg)

  File.open('./log/save_attach.log', 'a'){|f| f.write(msg << "\n")}
  
end
wiki_page = SWWIKI::WikiPage.new(wikipage_uri)
require 'uuidtools'
repository_path = "./applications/#{Application.active.name}/attachments"
adapter = ActiveRDF::ConnectionPool.adapters.first  
attachments.each{ |attParam|
  attachment_id = UUIDTools::UUID.random_create.to_s
  attachment_name = attParam.original_filename.to_s
  attachment_path = repository_path + "/" + attachment_id + "_" + attachment_name
  attachment_uri = "swwiki:" + attachment_id + "_" + attachment_name
  
  attachment = SWWIKI::FileAttachment.create(SWWIKI::.to_s + attachment_id)  
  attachment.save
  log_save_attach("PASSEI CREATE")  
  log_save_attach("NAME: " + attachment_name.class)  
  log_save_attach("PROPERTY: " + SWWIKI::attachmentName.to_s)  
  adapter.add(attachment, SWWIKI::attachmentName, attachment_name)
  log_save_attach("PASSEI NAME")
  adapter.add(attachment, SWWIKI::path, attachment_path)
  log_save_attach("PASSEI PATH")
  file = File.new(attachment.swwiki::path.to_s, "wb")
  file.write attParam.read
  file.close
  
  adapter.add(wiki_page, SWWIKI::hasAttachment, attachment)
  wiki_page.save  
}