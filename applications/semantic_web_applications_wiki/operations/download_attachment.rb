		def self.log_d(msg)
			File.open('./log/download.log', 'a'){|f| f.write(msg << "\n")}
		end
log_d(params[:uri])
attachment = SWWIKI::FileAttachment.new(params[:uri])
log_d(attachment.swwiki::path.to_s)
attachments_path = "./applications/#{Application.active.name}/attachments/"
send_file(attachments_path + attachment.swwiki::path.to_s.split("/").last, {:filename => attachment.swwiki::attachmentName})