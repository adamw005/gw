# Paperclip.options[:command_path] = 'C:/Program Files/ImageMagick-7.0.5-Q16'

Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
