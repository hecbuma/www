Airbrake.configure do |c|
  c.environment         = Rails.env
  c.logger              = Rails.logger
  c.project_id          = ENV['AIRBRAKE_PROJECT_ID']
  c.project_key         = ENV['AIRBRAKE_API_KEY']
  c.root_directory      = Rails.root
  c.blacklist_keys      = [/password/i]
end unless Rails.env.production?
