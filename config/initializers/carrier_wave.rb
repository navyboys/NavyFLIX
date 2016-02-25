CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :aws
    config.aws_bucket = 'navyflix'
    config.aws_acl = 'public-read'
    config.aws_credentials = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'us-west-2'
    }
    # config.fog_provider = 'fog/aws'
    # config.fog_credentials = {
    #   provider:              'AWS',                        # required
    #   aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
    #   aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required
    # }
    # config.fog_directory  = 'navyflix'                     # required
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
