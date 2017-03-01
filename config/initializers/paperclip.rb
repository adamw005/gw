Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_protocol] = 'http'
Paperclip::Attachment.default_options[:s3_credentials] =
  { :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
	 	s3_region: ENV['AWS_REGION']
	}
#
# Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
# Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
#
# # Paperclip.options[:command_path] = 'C:/Program Files/ImageMagick-7.0.5-Q16'
#
# # Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
# # Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
#
# # Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-1.amazonaws.com'
#
#
# # When only top Section:
# 	# Read-only file system @ dir_s_mkdir - /projects
# # When only bottom Section:
# 	# It doesn't use AWS, uses local storage
# # When both:
# 	# Read-only file system @ dir_s_mkdir - /projects
# # When none:
# 	# It doesn't use AWS, uses local storage
