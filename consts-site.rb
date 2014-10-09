MushroomObserver::Application.configure do
  config.action_mailer.smtp_settings[:password] = "xxx"
  config.pivotal_enabled = true
  config.pivotal_token = "xxx"
  config.image_sources[:cdmr].delete(:write)
end
