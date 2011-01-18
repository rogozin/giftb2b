if defined? ActionDispatch::Http::UploadedFile
  ActionDispatch::Http::UploadedFile.send(:include, Paperclip::Upfile)
end
Paperclip.interpolates :firm_id do |attachment, style|
  attachment.instance.firm_id
end
