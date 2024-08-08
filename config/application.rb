require_relative 'boot'
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InssProject
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller
    config.responders.flash_keys = [ :success, :error ]

    # TimeZone
    config.time_zone = 'America/Sao_Paulo'
    config.active_record.default_timezone = :local
    # config.active_record.time_zone_aware_attributes = 'America/Sao_Paulo'

    # I18n
    config.i18n.default_locale = 'pt-BR'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_job.queue_adapter = :sidekiq
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #    RenderAsync.configure do |config|
    #  config.jquery = true # This will render jQuery code, and skip Vanilla JS code
    #  config.turbolinks = false # Enable this option if you are using Turbolinks 5+
    #end
  end
end
