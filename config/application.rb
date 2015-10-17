require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImpactRails
  class Application < Rails::Application
    Plaid.config do |p|
      p.customer_id = Rails.application.secrets.plaid_client_id
      p.secret = Rails.application.secrets.plaid_secret
      p.environment_location = 'https://tartan.plaid.com/'
      # i.e. 'https://tartan.plaid.com/' for development, or
      # 'https://api.plaid.com/' for production
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += %W(#{config.root}/app/services)
    config.eager_load_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/app/services/blog)
    config.autoload_paths += %W(#{config.root}/app/services/comment)
    config.autoload_paths += %W(#{config.root}/app/services/cause)
    config.autoload_paths += %W(#{config.root}/app/services/conversation)
    config.autoload_paths += %W(#{config.root}/app/services/message)
    config.autoload_paths += %W(#{config.root}/app/services/user)
    config.autoload_paths += %W(#{config.root}/app/services/plaid)
    config.autoload_paths += %W(#{config.root}/app/services/stripe)
    config.autoload_paths += %W(#{config.root}/app/services/organization)
  end
end
