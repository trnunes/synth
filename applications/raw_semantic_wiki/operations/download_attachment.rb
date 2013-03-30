		def self.log_d(msg)
			File.open('./log/download.log', 'a'){|f| f.write(msg << "\n")}
		end
log_d(params[:uri])
attachment = SWWIKI::FileAttachment.new(params[:uri])
log_d(attachment.swwiki::path.to_s)
send_file(attachment.swwiki::path.to_s, {:filename => attachment.swwiki::attachmentName})