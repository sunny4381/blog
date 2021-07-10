require_relative "boot"

require "rails/all"
require_relative "../lib/tenant_filter"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sophon
  class Application < Rails::Application
    config.middleware.insert_after ActionDispatch::HostAuthorization, TenantFilter
    config.middleware.delete ActionDispatch::HostAuthorization

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
